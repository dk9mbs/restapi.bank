import unittest

from core.database import CommandBuilderFactory
from core.database import FetchXmlParser
from config import CONFIG
from core.appinfo import AppInfo
from core.fetchxmlparser import FetchXmlParser
from core.plugin import Plugin
from services.database import DatabaseServices

#from bank_plugin_set_account_balance import execute
from bank_lib_account_tools import AccountTools

class TestFetchxmlParser(unittest.TestCase):
    def setUp(self):
        AppInfo.init(__name__, CONFIG['default'])
        session_id=AppInfo.login("root","password")
        self.context=AppInfo.create_context(session_id)

    def test_import(self):

        #record={"data": {"auftragskonto": {"value": "173001058"}} }

        #record={"data": {"Auftragskonto": {"value": "DE65259501300173001058", "old_value": ""} }}

        #plugin_context={"process_id": "1234567890"}
        #execute(self.context,plugin_context, record)

        account_tools=AccountTools(self.context)
        account_tools.recalc_balance("DE65259501300173001058")

        account_tools=AccountTools(self.context)
        account_tools.recalc_balance("173001058")

        #self.assertEqual(record['band_id']['value'], 90)
    def tearDown(self):
        AppInfo.save_context(self.context, True)
        AppInfo.logoff(self.context)


if __name__ == '__main__':
    unittest.main()
