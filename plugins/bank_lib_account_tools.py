import decimal

from core.fetchxmlparser import FetchXmlParser
from services.database import DatabaseServices
from core import log
from tuxlog_lib_cty import CtyImport
from services.fetchxml import build_fetchxml_by_alias
from core.plugin import ProcessTools

class AccountTools:
    def __init__(self, context):
        self._context=context
        self._balance=0

    def recalc_balance(self, account_id):
        context=self._context
        fetch=f"""
        <restapi type="select">
            <table name="bank_item" alias="i"/>
            <filter type="and">
                <condition field="account_id" alias="i" operator="=" value="{account_id}"/>
            </filter>
            <select>
                <field name="account_id" table_alias="i" alias="account_id" grouping="y"/>
                <field name="betrag" table_alias="i" func="sum" alias="betrag" header="Value (sum)"/>
            </select>
        </restapi>
        """

        fetchparser=FetchXmlParser(fetch,context)
        rs=DatabaseServices.exec(fetchparser, context,fetch_mode=0, run_as_system=False)

        if not rs.get_eof():
            account_activity=rs.get_result()[0]['betrag']
        else:
            account_activity=0


        fetch=build_fetchxml_by_alias(context,"bank_account",account_id,type="select")
        fetchparser=FetchXmlParser(fetch,context)
        rs=DatabaseServices.exec(fetchparser, context, fetch_mode=0, run_as_system=False)
        carry_over=decimal.Decimal(rs.get_result()[0]['carry_over'])

        data={"account_activity": account_activity, "balance": decimal.Decimal(account_activity)+decimal.Decimal(carry_over)}
        print(data)
        fetch=build_fetchxml_by_alias(context,"bank_account",account_id,data, type="update")
        fetchparser=FetchXmlParser(fetch,context)
        rs=DatabaseServices.exec(fetchparser, context,fetch_mode=0, run_as_system=False)

        self._balance=account_activity

        return True


