/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

This schema file is for the sample of INTER-Mediator using SQLite3.

Example of making database file for UNIX (including OS X):

$ sudo mkdir /var/db/im
$ sudo sqlite3 /var/db/im/sample.sq3 < sample_schema_sqlite.txt
$ sudo chown _www /var/db/im
$ sudo chown _www /var/db/im/sample.sq3

- "sample_schema_sqlite.txt" is this schema file.
- "sample.sq3" is database file.
- The full path of the database file should be specified on each definiton file.
*/

/*  The schema for the "Sample_form" and "Sample_Auth" sample set.*/
CREATE TABLE person	(
	id			INTEGER PRIMARY KEY AUTOINCREMENT,
	name		TEXT,
	address		TEXT,
	mail		TEXT,
	category	INTEGER,
	checking	INTEGER,
	location	INTEGER,
	memo		TEXT
);
CREATE UNIQUE INDEX person_id ON person (id);

INSERT INTO person(id,name,address,mail) VALUES (1,'Masayuki Nii','Saitama, Japan','msyk@msyk.net');
INSERT INTO person(id,name,address,mail) VALUES (2,'Someone','Tokyo, Japan','msyk@msyk.net');
INSERT INTO person(id,name,address,mail) VALUES (3,'Anyone','Osaka, Japan','msyk@msyk.net');

CREATE TABLE contact	(
	id			INTEGER  PRIMARY KEY AUTOINCREMENT,
	person_id	INTEGER,
	description	TEXT,
	datetime	DATETIME,
	summary		TEXT,
	important	INTEGER,
	way 		INTEGER     default 4,
	kind		INTEGER
);
CREATE UNIQUE INDEX contact_id ON contact (id);
CREATE INDEX contact_person_id ON contact (person_id);

INSERT INTO contact (person_id,datetime,summary,way,kind) VALUES (1,'2009-12-01 15:23:00','Telephone',4,4);
INSERT INTO contact (person_id,datetime,summary,important,way,kind) VALUES (1,'2009-12-02 15:23:00','Meeting',1,4,7);
INSERT INTO contact (person_id,datetime,summary,way,kind) VALUES (1,'2009-12-03 15:23:00','Mail',5,8);
INSERT INTO contact (person_id,datetime,summary,way,kind) VALUES (2,'2009-12-04 15:23:00','Calling',6,12);
INSERT INTO contact (person_id,datetime,summary,way,kind) VALUES (2,'2009-12-01 15:23:00','Telephone',4,4);
INSERT INTO contact (person_id,datetime,summary,important,way,kind) VALUES (3,'2009-12-02 15:23:00','Meeting',1,4,7);
INSERT INTO contact (person_id,datetime,summary,way,kind) VALUES (3,'2009-12-03 15:23:00','Mail',5,8);

CREATE TABLE contact_way	(
	id		INTEGER PRIMARY KEY AUTOINCREMENT,
	name	TEXT
);
CREATE UNIQUE INDEX contact_way_id ON contact_way (id);

INSERT INTO contact_way(id,name) VALUES(4,'Direct');
INSERT INTO contact_way(id,name) VALUES(5,'Indirect');
INSERT INTO contact_way(id,name) VALUES(6,'Others');

CREATE TABLE contact_kind	(
	id		INTEGER PRIMARY KEY AUTOINCREMENT,
	name	TEXT
);
CREATE UNIQUE INDEX contact_kind_id ON contact_kind (id);

INSERT INTO contact_kind(id,name) VALUES(4,'Talk');
INSERT INTO contact_kind(id,name) VALUES(5,'Meet');
INSERT INTO contact_kind(id,name) VALUES(6,'Calling');
INSERT INTO contact_kind(id,name) VALUES(7,'Meeting');
INSERT INTO contact_kind(id,name) VALUES(8,'Mail');
INSERT INTO contact_kind(id,name) VALUES(9,'Email');
INSERT INTO contact_kind(id,name) VALUES(10,'See on Web');
INSERT INTO contact_kind(id,name) VALUES(11,'See on Chat');
INSERT INTO contact_kind(id,name) VALUES(12,'Twitter');
INSERT INTO contact_kind(id,name) VALUES(13,'Conference');

CREATE TABLE cor_way_kind	(
	id		INTEGER PRIMARY KEY AUTOINCREMENT,
	way_id	INTEGER,
	kind_id	INTEGER
);
CREATE INDEX cor_way_id ON cor_way_kind (way_id);
CREATE INDEX cor_kind_id ON cor_way_kind (way_id);

CREATE VIEW cor_way_kindname AS SELECT cor_way_kind.*,contact_kind.name as name_kind
FROM cor_way_kind, contact_kind
WHERE cor_way_kind.kind_id = contact_kind.id;

INSERT INTO cor_way_kind(way_id,kind_id) VALUES (4,4);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (4,5);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (5,6);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (4,7);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (5,8);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (5,9);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (6,10);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (5,11);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (6,12);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (5,12);
INSERT INTO cor_way_kind(way_id,kind_id) VALUES (6,13);

CREATE TABLE history	(
	id			INTEGER PRIMARY KEY AUTOINCREMENT,
	person_id	INTEGER,
	description	TEXT,
	startdate	DATE,
	enddate		DATE,
	username    TEXT
);
CREATE UNIQUE INDEX history_id ON history (id);
CREATE INDEX history_person_id ON history (person_id);

INSERT INTO history(person_id,startdate,enddate,description) VALUES(1,'2001-04-01','2003-03-31','Hight School');
INSERT INTO history(person_id,startdate,enddate,description) VALUES(1,'2003-04-01','2007-03-31','University');

/* The schema for the "Sample_search" sample set.*/

CREATE TABLE postalcode	(
	id	INTEGER PRIMARY KEY AUTOINCREMENT,
	f3	TEXT,
	f7	TEXT,
	f8	TEXT,
	f9	TEXT,
	memo	TEXT
);
CREATE UNIQUE INDEX postalcode_id ON postalcode (id);
CREATE INDEX postalcode_f3 ON postalcode (f3);
CREATE INDEX postalcode_f8 ON postalcode (f8);
/*
# The schema for the "Sample_products" sample set.
#
# The sample data for these table, invoice, item and products is another part of this file.
# Please scroll down to check it.
 */
CREATE TABLE invoice (
	id		  INTEGER PRIMARY KEY AUTOINCREMENT,
	issued	  DATE,
	title	  TEXT,
	authuser  TEXT,
	authgroup TEXT,
	authpriv  TEXT
);

CREATE TABLE item (
	id				INTEGER PRIMARY KEY AUTOINCREMENT,
	invoice_id		INTEGER,
	category_id	    INTEGER,
	product_id		INTEGER,
	qty				INTEGER,
	unitprice		FLOAT(10.2),
    user_id INTEGER,
    group_id INTEGER,
    priv_id INTEGER
);

CREATE TABLE product (
	id					INTEGER PRIMARY KEY AUTOINCREMENT,
	category_id		INTEGER,
	unitprice			FLOAT(10.2),
	name				TEXT,
	photofile			TEXT,
	acknowledgement	    TEXT,
	ack_link			TEXT,
	memo				TEXT
);
/*
CREATE VIEW item_display AS
    SELECT item.id, item.invoice_id, item.product_id, item.category_id, product.name, item.qty,
        item.unitprice, product.unitprice as unitprice_master,
        IF(item.unitprice is null, qty * product.unitprice, qty * item.unitprice) AS amount FROM item,
        product WHERE item.product_id=product.id;
*/

/* The schema for the "Sample_Asset" sample set. */

DROP TABLE IF EXISTS asset;
CREATE TABLE asset	(
	asset_id	INTEGER PRIMARY KEY AUTOINCREMENT,
	name		VARCHAR(20),
	category	VARCHAR(20),
    manifacture VARCHAR(20),
    productinfo VARCHAR(20),
	purchase    DATE,
    discard     DATE,
    memo	    TEXT
);
CREATE UNIQUE INDEX asset_id ON asset (asset_id);
CREATE INDEX asset_purchase ON asset (purchase);
CREATE INDEX asset_discard ON asset (discard);

DROP TABLE IF EXISTS rent;
CREATE TABLE rent	(
	rent_id		INTEGER PRIMARY KEY AUTOINCREMENT,
	asset_id  	INT,
	staff_id    INT,
	rentdate    DATE,
    backdate    DATE,
    memo	    TEXT
);
CREATE UNIQUE INDEX rent_id ON rent (rent_id);
CREATE INDEX rent_rentdate  ON rent (rentdate);
CREATE INDEX rent_backdate  ON rent (backdate);
CREATE INDEX rent_asset_id  ON rent (asset_id);
CREATE INDEX rent_staff_id  ON rent (staff_id);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff	(
	staff_id	INTEGER PRIMARY KEY AUTOINCREMENT,
	name		VARCHAR(20),
    section     VARCHAR(20),
    memo	    TEXT
);
CREATE UNIQUE INDEX staff_id ON staff (staff_id);

DROP TABLE IF EXISTS category;
CREATE TABLE category	(
	category_id	INTEGER PRIMARY KEY AUTOINCREMENT,
	name		VARCHAR(20)
);
CREATE UNIQUE INDEX category_id ON category (category_id);

/* The schema for the "Sample_Auth" sample set. */

CREATE TABLE chat (
	id			INTEGER PRIMARY KEY AUTOINCREMENT,
	user		TEXT,
	groupname   TEXT,
	postdt      DATETIME,
	message     TEXT
);

/* Observable */

CREATE TABLE registeredcontext (
	id	           INTEGER PRIMARY KEY AUTOINCREMENT,
	clientid       TEXT,
	entity         TEXT,
	conditions     TEXT,
	registereddt   DATETIME
);

CREATE TABLE registeredpks (
	context_id INTEGER,
	pk         INTEGER,
	PRIMARY KEY(context_id, pk),
	FOREIGN KEY(context_id) REFERENCES registeredcontext(id) ON DELETE CASCADE
);

CREATE TABLE authuser (
	id					INTEGER PRIMARY KEY AUTOINCREMENT,
	username			TEXT,
	hashedpasswd		TEXT,
	email               TEXT,
	realname			VARCHAR(20),
    limitdt             DateTime
);

CREATE INDEX authuser_username
  ON authuser (username);
CREATE INDEX authuser_email
  ON authuser (email);
CREATE INDEX authuser_limitdt
  ON authuser (limitdt);

INSERT INTO authuser(id,username,hashedpasswd) VALUES(1,'user1','d83eefa0a9bd7190c94e7911688503737a99db0154455354');
INSERT INTO authuser(id,username,hashedpasswd) VALUES(2,'user2','5115aba773983066bcf4a8655ddac8525c1d3c6354455354');
INSERT INTO authuser(id,username,hashedpasswd) VALUES(3,'user3','d1a7981108a73e9fbd570e23ecca87c2c5cb967554455354');
INSERT INTO authuser(id,username,hashedpasswd) VALUES(4,'user4','8c1b394577d0191417e8d962c5f6e3ca15068f8254455354');
INSERT INTO authuser(id,username,hashedpasswd) VALUES(5,'user5','ee403ef2642f2e63dca12af72856620e6a24102d54455354');
INSERT INTO authuser(id,username,hashedpasswd) VALUES(6,'mig2m','cd85a299c154c4714b23ce4b63618527289296ba6642c2685651ad8b9f20ce02285d7b34');
INSERT INTO authuser(id,username,hashedpasswd) VALUES(7,'mig2','fcc2ab4678963966614b5544a40f4b814ba3da41b3b69df6622e51b74818232864235970');
/*
# The user1 has the password 'user1'. It's salted with the string 'TEXT'.
# All users have the password the same as user name. All are salted with 'TEXT'
# The following command lines are used to generate above hashed-hexed-password.
#
#  $ echo -n 'user1TEST' | openssl sha1 -sha1
#  d83eefa0a9bd7190c94e7911688503737a99db01
#  echo -n 'TEST' | xxd -ps
#  54455354
#  - combine above two results:
#  d83eefa0a9bd7190c94e7911688503737a99db0154455354
*/
CREATE TABLE authgroup (
	id					INTEGER PRIMARY KEY AUTOINCREMENT,
	groupname			TEXT
);

INSERT INTO authgroup(id,groupname) VALUES(1,'group1');
INSERT INTO authgroup(id,groupname) VALUES(2,'group2');
INSERT INTO authgroup(id,groupname) VALUES(3,'group3');

CREATE TABLE authcor (
	id					INTEGER PRIMARY KEY AUTOINCREMENT,
	user_id             INTEGER,
	group_id            INTEGER,
	dest_group_id       INTEGER,
	privname			TEXT
);

CREATE INDEX authcor_user_id
  ON authcor (user_id);
CREATE INDEX authcor_group_id
  ON authcor (group_id);
CREATE INDEX authcor_dest_group_id
  ON authcor (dest_group_id);

INSERT INTO authcor(user_id,dest_group_id) VALUES(1,1);
INSERT INTO authcor(user_id,dest_group_id) VALUES(2,1);
INSERT INTO authcor(user_id,dest_group_id) VALUES(3,1);
INSERT INTO authcor(user_id,dest_group_id) VALUES(4,2);
INSERT INTO authcor(user_id,dest_group_id) VALUES(5,2);
INSERT INTO authcor(user_id,dest_group_id) VALUES(4,3);
INSERT INTO authcor(user_id,dest_group_id) VALUES(5,3);
INSERT INTO authcor(group_id,dest_group_id) VALUES(1,3);

CREATE TABLE issuedhash (
	id				INTEGER PRIMARY KEY AUTOINCREMENT,
	user_id         INTEGER,
	clienthost      TEXT,
	hash            TEXT,
	expired			DateTime
);

CREATE INDEX issuedhash_user_id
  ON issuedhash (user_id);
CREATE INDEX issuedhash_expired
  ON issuedhash (expired);
CREATE INDEX issuedhash_clienthost
  ON issuedhash (clienthost);
CREATE INDEX issuedhash_user_id_clienthost
  ON issuedhash (user_id, clienthost);

/* Operation Log Store */
CREATE TABLE operationlog (
	id				INTEGER PRIMARY KEY AUTOINCREMENT,
	dt          	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	user            VARCHAR(48),
	client_id_in    VARCHAR(48),
	client_id_out   VARCHAR(48),
	require_auth    BIT(1),
	set_auth        BIT(1),
	client_ip       VARCHAR(60),
	path            VARCHAR(256),
	access          VARCHAR(20),
	context         VARCHAR(50),
	get_data        TEXT,
	post_data       TEXT,
	result          TEXT,
	error           TEXT
);
/* In case of real deployment, some indices are required for quick operations. */

CREATE TABLE testtable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    num1 INT,
	num2 INT,
	num3 INT,
	dt1 DateTime,
	dt2 DateTime,
	dt3 DateTime,
	date1 Date,
	date2 Date,
	time1 Time,
	time2 Time,
	ts1 Timestamp DEFAULT CURRENT_TIMESTAMP,
	ts2 Timestamp DEFAULT '2001-01-01 00:00:00',
	vc1 VARCHAR(100),
	vc2 VARCHAR(100),
	vc3 VARCHAR(100),
	text1 TEXT,
	text2 TEXT
);
