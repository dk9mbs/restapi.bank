import hashlib

from core.fetchxmlparser import FetchXmlParser
from services.database import DatabaseServices
from core import log
from services.fetchxml import build_fetchxml_by_alias
from core.plugin import ProcessTools
from core.file_system_tools import get_file_content

from bank_lib_csvmt940 import CSVMT940Reader
from bank_lib_account_tools import AccountTools


class CategoryRule(object):
    def __init__(self, context):
        self._context=context

    def execute(self):

        fetch=f"""
        <restapi type="select">
            <table name="bank_item_category_rule" alias="r"/>
            <select>
            <field name="id" table_alias="r"/>
            <field name="name" table_alias="r"/>
            <field name="field" table_alias="r"/>
            <field name="operator" table_alias="r"/>
            <field name="value" table_alias="r"/>
            <field name="category_id" table_alias="r"/>
            </select>
        </restapi>
        """
        fetchparser=FetchXmlParser(fetch,self._context)
        rs=DatabaseServices.exec(fetchparser, self._context,fetch_mode=0, run_as_system=True)

        for category in rs.get_result():
            fetch=f"""
            <restapi type="update">
                <table name="bank_item"/>
                <fields>
                    <field name="category_id" value="{category['category_id']}"/>
                </fields>
                <filter type="and">
                    <condition field="{category['field']}" value="{category['value']}" operator="{category['operator']}"/>
                </filter>
            </restapi>
            """
            fetchparser=FetchXmlParser(fetch,self._context)
            DatabaseServices.exec(fetchparser, self._context,fetch_mode=0, run_as_system=True)

        rs.close()
