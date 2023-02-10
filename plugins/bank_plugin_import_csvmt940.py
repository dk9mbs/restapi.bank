import hashlib

from core.fetchxmlparser import FetchXmlParser
from services.database import DatabaseServices
from core import log
from services.fetchxml import build_fetchxml_by_alias
from core.plugin import ProcessTools
from core.file_system_tools import get_file_content

from bank_lib_csvmt940 import CSVMT940Reader
from bank_lib_account_tools import AccountTools

def __validate(params):
    if 'data' not in params:
        return False

    if 'file_full_name' not in params['data']:
        return False

    return True


def fn_line(context, line_json):
    if line_json['Info']!="Umsatz gebucht":
        print(line_json['Info'])
        return

    plugin_context=context.get_userdata('plugin_context')
    ProcessTools.set_process_status_info(context, plugin_context, f"{line_json['Verwendungszweck']}")

    fetch=build_fetchxml_by_alias(context,"bank_item",line_json['id'],type="select")
    fetchparser=FetchXmlParser(fetch,context)
    rs=DatabaseServices.exec(fetchparser, context,fetch_mode=0, run_as_system=False)

    if rs.get_eof()==True:
        print(f"New: {line_json}")
        fetch=build_fetchxml_by_alias(context,"bank_item",line_json['id'],line_json,type="insert")
        fetchparser=FetchXmlParser(fetch,context)
        rs=DatabaseServices.exec(fetchparser, context,fetch_mode=0, run_as_system=False)

def fn_unique(context, line_json):
    fetch=build_fetchxml_by_alias(context,"bank_account_mapping",line_json['Auftragskonto'],type="select")
    fetchparser=FetchXmlParser(fetch,context)
    rs=DatabaseServices.exec(fetchparser, context,fetch_mode=0, run_as_system=False)
    if rs.get_eof():
        data={"id":line_json['Auftragskonto'], "map_to": line_json['Auftragskonto']}
        fetch=build_fetchxml_by_alias(context,"bank_account_mapping",data=data,type="insert")
        fetchparser=FetchXmlParser(fetch,context)
        DatabaseServices.exec(fetchparser, context,fetch_mode=0, run_as_system=False)
        line_json['account_id']=line_json['Auftragskonto']
    else:
        line_json['account_id']=rs.get_result()[0]['map_to']


def recalc_all_accounts(context):
    plugin_context=context.get_userdata('plugin_context')

    fetch=f"""
    <restapi type="select">
        <table name="bank_account" alias="i"/>
        <select>
            <field name="id" table_alias="i"/>
        </select>
    </restapi>
    """

    fetchparser=FetchXmlParser(fetch,context)
    rs=DatabaseServices.exec(fetchparser, context,fetch_mode=0, run_as_system=False)

    for account in rs.get_result():
        ProcessTools.set_process_status_info(context, plugin_context, f"recalc_account {account['id']}")
        account_tools=AccountTools(context)
        account_tools.recalc_balance(account['id'])



def execute(context, plugin_context, params):
    if not __validate(params):
        log.create_logger(__name__).warning(f"Missings params")
        return

    context.set_userdata('plugin_context', plugin_context)
    file_full_name=params['data']['file_full_name']
    content=get_file_content(file_full_name)

    fr=CSVMT940Reader(context, content)
    fr.read(fn_line, fn_unique)

    recalc_all_accounts(context)

    ProcessTools.set_process_status_info(context, plugin_context, f"Ready!")



