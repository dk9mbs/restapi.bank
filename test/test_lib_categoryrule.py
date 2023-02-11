import unittest

from core.database import CommandBuilderFactory
from core.database import FetchXmlParser
from config import CONFIG
from core.appinfo import AppInfo
from core.fetchxmlparser import FetchXmlParser
from core.plugin import Plugin
from services.database import DatabaseServices
from core.encoding_tools import get_file_encoding

from plugins.bank_lib_categoryrule import CategoryRule

class TestFetchxmlParser(unittest.TestCase):
    def setUp(self):
        AppInfo.init(__name__, CONFIG['default'])
        session_id=AppInfo.login("root","password")
        self.context=AppInfo.create_context(session_id)

    def test_import(self):

        rule=CategoryRule(self.context)
        rule.execute()
        #self.assertEqual(record['band_id']['value'], 90)
    def tearDown(self):
        AppInfo.save_context(self.context, True)
        AppInfo.logoff(self.context)


if __name__ == '__main__':
    unittest.main()
