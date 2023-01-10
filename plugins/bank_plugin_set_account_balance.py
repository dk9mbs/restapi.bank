from core.fetchxmlparser import FetchXmlParser
from services.database import DatabaseServices
from core import log
from tuxlog_lib_cty import CtyImport
from services.fetchxml import build_fetchxml_by_alias
from core.plugin import ProcessTools
from bank_lib_account_tools import AccountTools

def __validate(params):
    if 'data' not in params:
        return False

    return True

def execute(context, plugin_context, params):
    if not __validate(params):
        log.create_logger(__name__).warning(f"Missings params")
        return
    print(params)
    ProcessTools.set_process_status_info(context, plugin_context, f"")


    account=AccountTools(context)
    account.recalc_balance(params['data']['Auftragskonto']['value'])

    ProcessTools.set_process_status_info(context, plugin_context, f"Ready!")



