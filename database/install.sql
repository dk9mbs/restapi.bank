DELETE FROM api_process_log WHERE event_handler_id IN (SELECT id FROM api_event_handler WHERE solution_id=10003);
DELETE FROM api_group_permission WHERE solution_id=10003;
DELETE FROM api_user_group WHERE solution_id=10003;
DELETE FROM api_session WHERE user_id IN(100030001);
DELETE FROM api_user WHERE solution_id=10003;
DELETE FROM api_group WHERE solution_id=10003;
DELETE FROM api_event_handler WHERE solution_id=10003;
DELETE FROM api_table_view where solution_id=10003;
DELETE FROM api_ui_app_nav_item WHERE solution_id=10003;

/*
Tables
*/
CREATE TABLE IF NOT EXISTS bank_item_category(
    id varchar(50) NOT NULL,
    name varchar(100) NOT NULL,
    created_on timestamp default CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT IGNORE INTO bank_item_category(id, name) VALUES('SPAREN','Sparen');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('TANKEN','Tanken');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('KFZ','KFZ');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('MIETE','Miete');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('KOMMUNIKATION','Kommunikation');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('HOBBY','Hobby');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('VERSICHERUNG','Versicherungen');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('GARTEN','Garten');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('KLEIDUNG','Kleidung');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('EINKOMMEN','Lohn / Gehalt');
INSERT IGNORE INTO bank_item_category(id, name) VALUES('URLAUB','Urlaub');

CREATE TABLE IF NOT EXISTS bank_currency(
    id varchar(10) NOT NULL,
    name varchar(50) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE KEY(name)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT IGNORE bank_currency(id,name) VALUES ('EUR','Euro');
INSERT IGNORE bank_currency(id,name) VALUES ('USD','US Dollar');

CREATE TABLE IF NOT EXISTS bank_account_mapping(
    id varchar(50) NOT NULL,
    map_to varchar(50) NOT NULL,
    PRIMARY KEY(id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS bank_account(
    id varchar(50) NOT NULL,
    name varchar(100) NOT NULL,
    balance decimal(10,2) NOT NULL DEFAULT '0',
    account_activity decimal(10,2) NOT NULL DEFAULT '0',
    carry_over decimal(10,2) NOT NULL DEFAULT '0',
    carry_over_on datetime NULL,
    currency_id varchar(10) NOT NULL DEFAULT 'EUR',
    PRIMARY KEY(id),
    FOREIGN KEY(currency_id) references bank_currency(id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS bank_item(
    id varchar(100) NOT NULL,
    auftragskonto varchar(100),
    buchungstag datetime,
    valutadatum datetime,
    buchungstext varchar(1000),
    verwendungszweck text,
    beguenstigter_zahlungspflichtiger varchar(1000),
    kontonummer varchar(100),
    blz varchar(100),
    betrag decimal (10,2),
    waehrung varchar(10),
    info varchar(250),
    created_on timestamp default CURRENT_TIMESTAMP NOT NULL,
    category_id varchar(50) NULL,
    account_id varchar(50) NULL,
    id_raw text,
    FOREIGN KEY(category_id) references bank_item_category(id),
    FOREIGN KEY(account_id) references bank_account(id),
    PRIMARY KEY(id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

call api_proc_create_table_field_instance(100030001,10, 'id','ID', 'string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,20,'auftragskonto','Auftragskonto','string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,30, 'buchungstag','Buchungsdatum','datetime',9,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,40, 'valutadatum','Valutadatum','datetime',9,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,50, 'buchungstext','Buchungstext','string',18,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,60, 'verwendungszweck','Verwendungszweck','string',18,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,70, 'beguenstigter_zahlungspflichtiger','Zahlungspflichtiger','string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,80, 'kontonummer','Kontonummer','string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,90, 'blz','BLZ','string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,100, 'betrag','Betrag','decimal',14,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,110, 'waehrung','Wkz','string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,120, 'info','Info','string',18,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,130, 'created_on','Erstellt am','datetime',9,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,140, 'category_id','Kategorie','string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,150, 'account_id','Konto','string',1,'{"disabled": true}', @out_value);
call api_proc_create_table_field_instance(100030001,160, 'id_raw','Rohdaten (ID)','string',18,'{"disabled": true}', @out_value);


CREATE TABLE IF NOT EXISTS bank_item_category_mapping(
    id int NOT NULL auto_increment,
    field_name varchar(100) NOT NULL COMMENT 'For example: Konto',
    value text NOT NULL COMMENT '',
    category_id varchar(50) NULL,
    created_on timestamp default CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(category_id) references bank_item_category(id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;



/*
Meta Data
*/
INSERT IGNORE INTO api_solution(id,name) VALUES (10003, 'Kassenbuch');
INSERT IGNORE INTO api_user (id,username,password,is_admin,disabled,solution_id) VALUES (100030001,'bank','password',0,0,10003);
INSERT IGNORE INTO api_group(id,groupname,solution_id) VALUES (100030001,'bank',10003);
INSERT IGNORE INTO api_user_group(user_id,group_id,solution_id) VALUES (100030001,100030001,10003);

INSERT IGNORE INTO api_table(id,alias,table_name,id_field_name,id_field_type,desc_field_name,enable_audit_log,solution_id)
    VALUES
    (100030001,'bank_item','bank_item','id','string','verwendungszweck',-1,10003);

INSERT IGNORE INTO api_table(id,alias,table_name,id_field_name,id_field_type,desc_field_name,enable_audit_log,solution_id)
    VALUES
    (100030002,'bank_item_category','bank_item_category','id','string','name',-1,10003);

call api_proc_create_table_field_instance(100030002,10, 'id','ID','string',1,'{disabled: false}', @out_value);
call api_proc_create_table_field_instance(100030002,20, 'name','Bezeichnung','string',1,'{disabled: false}', @out_value);
call api_proc_create_table_field_instance(100030002,30, 'datetime','Erstellt am','datetime',9,'{disabled: true}', @out_value);


INSERT IGNORE INTO api_table(id,alias,table_name,id_field_name,id_field_type,desc_field_name,enable_audit_log,solution_id)
    VALUES
    (100030003,'bank_item_category_mapping','bank_item_category_mapping','id','int','konto',-1,10003);

INSERT IGNORE INTO api_table(id,alias,table_name,id_field_name,id_field_type,desc_field_name,enable_audit_log,solution_id)
    VALUES
    (100030004,'bank_currency','bank_currency','id','string','name',-1,10003);

INSERT IGNORE INTO api_table(id,alias,table_name,id_field_name,id_field_type,desc_field_name,enable_audit_log,solution_id)
    VALUES
    (100030005,'bank_account','bank_account','id','string','name',-1,10003);

INSERT IGNORE INTO api_table(id,alias,table_name,id_field_name,id_field_type,desc_field_name,enable_audit_log,solution_id)
    VALUES
    (100030006,'bank_account_mapping','bank_account_mapping','id','string','map_to',-1,10003);


INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030005, 'ID','id','string','{"disabled": false}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030005, 'Name','name','string','{"disabled": false}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030005, 'Währung','currency_id','string','{"disabled": false}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030005, 'Kontostand','balance','decimal','{"disabled": true}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030005, 'Bewegungen','account_activity','decimal','{"disabled": true}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030005, 'Saldo','carry_over','decimal','{"disabled": false}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030005, 'Saldo am','carry_over_on','date','{"disabled": false}');

INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030004, 'ID','id','string','{"disabled": false}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030004, 'Name','name','string','{"disabled": false}');

INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030006, 'Kontonummer (extern)','id','string','{"disabled": false}');
INSERT IGNORE INTO api_table_field (table_id,label,name,type_id,control_config) VALUES(100030006, 'Kontonummer (intern)','map_to','string','{"disabled": false}');


INSERT IGNORE INTO api_ui_app (id, name,description,home_url,solution_id)
VALUES (
100030001,'Kassenbuch','Kassenbuch','/ui/v1.0/data/view/bank_item/default?app_id=100030001',10003);

INSERT IGNORE INTO api_ui_app_nav_item(id, app_id,name,url,type_id,solution_id) VALUES (
100030001,100030001,'Buchungen','/ui/v1.0/data/view/bank_item/default',1,10003);

INSERT IGNORE INTO api_ui_app_nav_item(id, app_id,name,url,type_id,solution_id) VALUES (
100030002,100030001,'Bank Konten','/ui/v1.0/data/view/bank_account/default',1,10003);

INSERT IGNORE INTO api_ui_app_nav_item(id, app_id,name,url,type_id,solution_id) VALUES (
100030003,100030001,'Bank Konten Mapping','/ui/v1.0/data/view/bank_account_mapping/default',1,10003);



INSERT IGNORE INTO api_group_permission (group_id,table_id,mode_create,mode_read,mode_update,mode_delete,solution_id)
    VALUES
    (100030001,100030001,-1,-1,-1,-1,10003);

INSERT IGNORE INTO api_group_permission (group_id,table_id,mode_create,mode_read,mode_update,mode_delete,solution_id)
    VALUES
    (100030001,100030002,-1,-1,-1,-1,10003);

INSERT IGNORE INTO api_group_permission (group_id,table_id,mode_create,mode_read,mode_update,mode_delete,solution_id)
    VALUES
    (100030001,100030003,-1,-1,-1,-1,10003);

INSERT IGNORE INTO api_group_permission (group_id,table_id,mode_create,mode_read,mode_update,mode_delete,solution_id)
    VALUES
    (100030001,100030004,-1,-1,-1,-1,10003);

INSERT IGNORE INTO api_group_permission (group_id,table_id,mode_create,mode_read,mode_update,mode_delete,solution_id)
    VALUES
    (100030001,100030005,-1,-1,-1,-1,10003);

INSERT IGNORE INTO api_group_permission (group_id,table_id,mode_create,mode_read,mode_update,mode_delete,solution_id)
    VALUES
    (100030001,100030006,-1,-1,-1,-1,10003);


INSERT IGNORE INTO api_event_handler (id, plugin_module_name,publisher,event,type,sorting,solution_id,run_async, run_queue)
    VALUES (100030001, 'bank_plugin_import_csvmt940','textfileimport2_csvmt940','post','before',100,10003,-1,0);

/*
INSERT IGNORE INTO api_event_handler (id, plugin_module_name,publisher,event,type,sorting,solution_id,run_async, run_queue)
    VALUES (100030002, 'bank_plugin_set_account_balance','bank_item','insert','after',100,10003,-1,-1);
*/

INSERT IGNORE INTO api_table_view (id,type_id,name,table_id,id_field_name,solution_id,fetch_xml) VALUES (
100030001,'LISTVIEW','default',100030001,'id',10003,'<restapi type="select">
    <table name="bank_item" alias="i"/>
    <filter type="or">
        <condition field="beguenstigter_zahlungspflichtiger" alias="i" value="$$query$$" operator="$$operator$$"/>
    </filter>
    <orderby>
        <field name="valutadatum" alias="i" sort="DESC"/>
    </orderby>
    <select>
        <field name="auftragskonto" table_alias="i" header="Auftragskonto"/>
        <field name="valutadatum" table_alias="i" header="Valutadatum"/>
        <field name="betrag" table_alias="i" header="Betrag"/>
        <field name="waehrung" table_alias="i" header="Wkz"/>
        <field name="verwendungszweck" table_alias="i" header="Verwendungszweck"/>
        <field name="info" table_alias="i" header="Info"/>
        <field name="id" table_alias="i" header="ID"/>
    </select>
</restapi>');



INSERT IGNORE INTO api_table_view (id,type_id,name,table_id,id_field_name,solution_id,fetch_xml) VALUES (
100030002,'LISTVIEW','default',100030005,'id',10003,'<restapi type="select">
    <table name="bank_account" alias="i"/>
    <filter type="or">
        <condition field="name" alias="i" value="$$query$$" operator="$$operator$$"/>
    </filter>
    <orderby>
        <field name="id" alias="i" sort="DESC"/>
    </orderby>
    <select>
        <field name="id" table_alias="i" header="ID"/>
        <field name="name" table_alias="i" header="Name"/>
        <field name="balance" table_alias="i" header="Bestand"/>
        <field name="account_activity" table_alias="i" header="Bewegungen"/>
        <field name="carry_over" table_alias="i" header="Saldo"/>
        <field name="carry_over_on" table_alias="i" header="Saldo vom"/>
        <field name="currency_id" table_alias="i" header="Wkz"/>
    </select>
</restapi>');

INSERT IGNORE INTO api_table_view (id,type_id,name,table_id,id_field_name,solution_id,fetch_xml) VALUES (
100030003,'LISTVIEW','default',100030006,'id',10003,'<restapi type="select">
    <table name="bank_account_mapping" alias="i"/>
    <filter type="or">
        <condition field="map_to" alias="i" value="$$query$$" operator="$$operator$$"/>
        <condition field="id" alias="i" value="$$query$$" operator="$$operator$$"/>
    </filter>
    <orderby>
        <field name="id" alias="i" sort="DESC"/>
    </orderby>
    <select>
        <field name="id" table_alias="i" header="Konto extern"/>
        <field name="map_to" table_alias="i" header="Konto intern"/>
    </select>
</restapi>');







