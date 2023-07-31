import hashlib
import re
import decimal

class CSVMT940Reader:
    def __init__(self, context, content):
        self._lines=[]
        self._titles=[]
        self._count=0
        self._content=content
        self._context=context

    def read(self, fn_line, fn_unique=None):
        content=self._content
        content=content.split('\n')

        titles=content[0]

        for title in titles.split(';'):
            if title!='' and title !='\n':
                self._titles.append(title.replace('/','_').replace('\"',''))

        y=1
        while True:
            tmp=content[y]
            y+=1
            if tmp=='':
                break

            tmp=tmp.split(';')
            if tmp[0]!='':
                line={}
                for x in range(len(self._titles)):
                    line[self._titles[x]]=str(tmp[x]).strip().replace('\"','')

                line['Betrag']=decimal.Decimal(str(line['Betrag']).replace(',','.'))

                line['Buchungstag']=f"20{str(line['Buchungstag'])[6:8]}-{str(line['Buchungstag'])[3:5]}-{str(line['Buchungstag'])[0:2]}"
                line['Valutadatum']=f"20{str(line['Valutadatum'])[6:8]}-{str(line['Valutadatum'])[3:5]}-{str(line['Valutadatum'])[0:2]}"

                whitelist=['AUFTRAGSKONTO', 'BUCHUNGSTAG', 'VALUTADATUM', 'BUCHUNGSTEXT', 'VERWENDUNGSZWECK', 'BEGUENSTIGTER_ZAHLUNGSPFLICHTIGER', 'KONTONUMMER', 'BLZ', 'BETRAG', 'WAEHRUNG', 'INFO', 'ACCOUNT_ID']
                blacklist=['KATEGORIE']
                numericlist=['BETRAG']

                if fn_unique!=None:
                    fn_unique(self._context, line)

                unique=""
                for key, value in line.items():
                    if key.upper() in whitelist:
                        if not key.upper() in blacklist:
                            if key.upper() in numericlist:
                                replaced_val="{:.2f}".format(value)
                            else:
                                replaced_val=re.sub(r"[^a-zA-Z0-9]","",str(value))

                            unique=f"{unique}{replaced_val};"

                #print(f"{line['Betrag']} {unique}")
                line['id']=hashlib.sha256(bytearray(unique,'UTF-8')).hexdigest()
                line['id_raw']=unique
                print(unique)
                fn_line(self._context, line)
                self._count+=1



if __name__=='__main__':
    f=open('Migration_mysql.csv','r')

    def fn_line(line_json):
        print(line_json)

    def fn_unique(titles, line_json):
        return "test"

    fr=CSVMT940Reader(f.read())
    fr.read(fn_line, None)
