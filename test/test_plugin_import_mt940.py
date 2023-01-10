import unittest

from core.database import CommandBuilderFactory
from core.database import FetchXmlParser
from config import CONFIG
from core.appinfo import AppInfo
from core.fetchxmlparser import FetchXmlParser
from core.plugin import Plugin
from services.database import DatabaseServices
from core.encoding_tools import get_file_encoding

from bank_plugin_import_csvmt940 import execute

class TestFetchxmlParser(unittest.TestCase):
    def setUp(self):
        AppInfo.init(__name__, CONFIG['default'])
        session_id=AppInfo.login("root","password")
        self.context=AppInfo.create_context(session_id)

    def test_import(self):
        #file='/home/dk9mbs/ownCloud/Documents/Unterlagen/Konto/test.CSV'
        #file='/home/dk9mbs/ownCloud/Documents/Unterlagen/Konto/20230106-173001058-umsatz.CSV'
        #file='/home/dk9mbs/ownCloud/Documents/Unterlagen/Konto/Migration_mysql.csv'
        file='/home/dk9mbs/ownCloud/Documents/Unterlagen/Konto/Startbestand.csv'

        encoding=get_file_encoding(file)

        f=open(file,'r', encoding=encoding)
        record={}
        plugin_context={"process_id": "1234567890"}
        content=str(f.read())
        execute(self.context,plugin_context, {"data": {"content":content}})
        #self.assertEqual(record['band_id']['value'], 90)
        f.close()
    def tearDown(self):
        AppInfo.save_context(self.context, True)
        AppInfo.logoff(self.context)


if __name__ == '__main__':
    unittest.main()
