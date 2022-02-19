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

CREATE TABLE account
(
    account_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    kind              TEXT, /* 領収書, 請求書 */
    tax_kind          INTEGER, /* 0=内税, 1=外税 */
    issued_date       DATE,
    description       TEXT,
    memo              TEXT,
    company_id        INTEGER,
    company           TEXT,
    section           TEXT,
    person            TEXT,
    postal_code       TEXT,
    address           TEXT,
    invoice_path      TEXT,
    tax_rate          REAL DEFAULT 0.1,
    debit_id          INTEGER, /* 借方コード */
    credit_id         INTEGER, /* 貸方コード */
    assort_pattern_id INTEGER /* 仕分けパターン番号 */
);

CREATE TABLE detail
(
    detail_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id  INTEGER,
    description TEXT,
    unit_price  INTEGER,
    qty         INTEGER,
    tax_rate    REAL DEFAULT 0.1
);

CREATE TABLE item
(
    item_id     INTEGER PRIMARY KEY,
    item_name   TEXT,
    alloc_rate  REAL, /* 組み込み比率 */
    show        INTEGER, /* 1=ポップアップ表示 */
    is_purchase INTEGER /* 仕入れに入れる項目 */
);

CREATE TABLE assort_pattern
(
    assort_pattern_id INTEGER PRIMARY KEY, /* 仕分けパターン番号 */
    pattern_name      TEXT,
    debit_id          INTEGER, /* 借方コード */
    credit_id         INTEGER /* 貸方コード */
);

CREATE TABLE company
(
    company_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    company     TEXT,
    section     TEXT,
    person      TEXT,
    postal_code TEXT,
    address     TEXT
);
/* Observable */
CREATE TABLE registeredcontext
(
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    clientid     TEXT,
    entity       TEXT,
    conditions   TEXT,
    registereddt DATETIME
);

CREATE TABLE registeredpks
(
    context_id INTEGER,
    pk         INTEGER,
    PRIMARY KEY (context_id, pk),
    FOREIGN KEY (context_id) REFERENCES registeredcontext (id) ON DELETE CASCADE
);

CREATE TABLE authuser
(
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    username     TEXT,
    hashedpasswd TEXT,
    email        TEXT,
    realname     VARCHAR(20),
    limitdt      DateTime
);

CREATE INDEX authuser_username
    ON authuser (username);
CREATE INDEX authuser_email
    ON authuser (email);
CREATE INDEX authuser_limitdt
    ON authuser (limitdt);

INSERT INTO authuser(id, username, hashedpasswd)
VALUES (1, 'user1', 'd83eefa0a9bd7190c94e7911688503737a99db0154455354');
INSERT INTO authuser(id, username, hashedpasswd)
VALUES (2, 'user2', '5115aba773983066bcf4a8655ddac8525c1d3c6354455354');
INSERT INTO authuser(id, username, hashedpasswd)
VALUES (3, 'user3', 'd1a7981108a73e9fbd570e23ecca87c2c5cb967554455354');
INSERT INTO authuser(id, username, hashedpasswd)
VALUES (4, 'user4', '8c1b394577d0191417e8d962c5f6e3ca15068f8254455354');
INSERT INTO authuser(id, username, hashedpasswd)
VALUES (5, 'user5', 'ee403ef2642f2e63dca12af72856620e6a24102d54455354');
INSERT INTO authuser(id, username, hashedpasswd)
VALUES (6, 'mig2m', 'cd85a299c154c4714b23ce4b63618527289296ba6642c2685651ad8b9f20ce02285d7b34');
INSERT INTO authuser(id, username, hashedpasswd)
VALUES (7, 'mig2', 'fcc2ab4678963966614b5544a40f4b814ba3da41b3b69df6622e51b74818232864235970');
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
CREATE TABLE authgroup
(
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    groupname TEXT
);

INSERT INTO authgroup(id, groupname)
VALUES (1, 'group1');
INSERT INTO authgroup(id, groupname)
VALUES (2, 'group2');
INSERT INTO authgroup(id, groupname)
VALUES (3, 'group3');

CREATE TABLE authcor
(
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id       INTEGER,
    group_id      INTEGER,
    dest_group_id INTEGER,
    privname      TEXT
);

CREATE INDEX authcor_user_id
    ON authcor (user_id);
CREATE INDEX authcor_group_id
    ON authcor (group_id);
CREATE INDEX authcor_dest_group_id
    ON authcor (dest_group_id);

INSERT INTO authcor(user_id, dest_group_id)
VALUES (1, 1);
INSERT INTO authcor(user_id, dest_group_id)
VALUES (2, 1);
INSERT INTO authcor(user_id, dest_group_id)
VALUES (3, 1);
INSERT INTO authcor(user_id, dest_group_id)
VALUES (4, 2);
INSERT INTO authcor(user_id, dest_group_id)
VALUES (5, 2);
INSERT INTO authcor(user_id, dest_group_id)
VALUES (4, 3);
INSERT INTO authcor(user_id, dest_group_id)
VALUES (5, 3);
INSERT INTO authcor(group_id, dest_group_id)
VALUES (1, 3);

CREATE TABLE issuedhash
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    clienthost TEXT,
    hash       TEXT,
    expired    DateTime
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
CREATE TABLE operationlog
(
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    dt            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user          VARCHAR(48),
    client_id_in  VARCHAR(48),
    client_id_out VARCHAR(48),
    require_auth  BIT(1),
    set_auth      BIT(1),
    client_ip     VARCHAR(60),
    path          VARCHAR(256),
    access        VARCHAR(20),
    context       VARCHAR(50),
    get_data      TEXT,
    post_data     TEXT,
    result        TEXT,
    error         TEXT
);
