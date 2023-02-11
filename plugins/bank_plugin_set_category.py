import datetime
import requests

from core.fetchxmlparser import FetchXmlParser
from services.database import DatabaseServices
from core import log
from plugins.bank_lib_categoryrule import CategoryRule

logger=log.create_logger(__name__)

def execute(context, plugin_context, params):
    rule=CategoryRule(context)
    rule.execute()

