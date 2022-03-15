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
    parent_account_id INTEGER,
    kind              TEXT, /* 領収書, 請求書 */
    tax_kind          INTEGER DEFAULT 0, /* 0=内税, 1=外税, 2=非課税 */
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
    title             TEXT,
    tax_rate          REAL    DEFAULT 0.1,
    debit_id          INTEGER DEFAULT 700, /* 借方コード */
    credit_id         INTEGER DEFAULT 141, /* 貸方コード */
    assort_pattern_id INTEGER /* 仕分けパターン番号 */
);

CREATE UNIQUE INDEX account_account_id
    ON account (account_id);
CREATE INDEX account_parent_account_id
    ON account (parent_account_id);
CREATE INDEX account_issued_date
    ON account (issued_date);
CREATE INDEX account_company
    ON account (company);
CREATE INDEX account_description
    ON account (description);
CREATE INDEX account_debit_id
    ON account (debit_id);
CREATE INDEX account_credit_id
    ON account (credit_id);
CREATE INDEX account_assort_pattern_id
    ON account (assort_pattern_id);

CREATE TABLE detail
(
    detail_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id  INTEGER,
    description TEXT,
    unit_price  REAL NOT NULL DEFAULT 0,
    qty         REAL NOT NULL DEFAULT 0,
    tax_rate    REAL
);

CREATE UNIQUE INDEX detail_detail_id
    ON detail (detail_id);
CREATE INDEX detail_account_id
    ON detail (account_id);

CREATE TABLE item
(
    item_id     INTEGER PRIMARY KEY,
    item_name   TEXT,
    alloc_rate  REAL, /* 組み込み比率 */
    show        INTEGER, /* 1=ポップアップ表示 */
    is_purchase INTEGER /* 仕入れに入れる項目 */
);

CREATE UNIQUE INDEX item_item_id
    ON item (item_id);

CREATE TABLE assort_pattern
(
    assort_pattern_id INTEGER PRIMARY KEY AUTOINCREMENT, /* 仕分けパターン番号 */
    pattern_name      TEXT,
    debit_id          INTEGER, /* 借方コード */
    credit_id         INTEGER /* 貸方コード */
);

CREATE UNIQUE INDEX assort_pattern_id
    ON assort_pattern (assort_pattern_id);

CREATE TABLE fiscal_year
(
    year INTEGER PRIMARY KEY
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

CREATE UNIQUE INDEX company_id
    ON company (company_id);

CREATE TABLE preference
(
    preference_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    myself          TEXT,
    bank_info       TEXT,
    show_tax_detail INTEGER DEFAULT 0 NOT NULL,
    show_label      INTEGER DEFAULT 1 NOT NULL,
    sender_info     TEXT
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

CREATE UNIQUE INDEX registeredcontext_id
    ON registeredcontext (id);
CREATE UNIQUE INDEX registeredpks_context_id
    ON registeredpks (context_id);
CREATE  INDEX registeredpks_pk
    ON registeredpks (pk);


CREATE TABLE authuser
(
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    username     TEXT,
    hashedpasswd TEXT,
    email        TEXT,
    realname     VARCHAR(20),
    limitdt      DateTime
);

CREATE UNIQUE INDEX authuser_id
    ON authuser (id);
CREATE INDEX authuser_username
    ON authuser (username);
CREATE INDEX authuser_email
    ON authuser (email);
CREATE INDEX authuser_limitdt
    ON authuser (limitdt);

CREATE TABLE authgroup
(
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    groupname TEXT
);

CREATE UNIQUE INDEX authgroup_id
    ON authgroup (id);

CREATE TABLE authcor
(
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id       INTEGER,
    group_id      INTEGER,
    dest_group_id INTEGER,
    privname      TEXT
);

CREATE UNIQUE INDEX authcor_id
    ON authcor (id);
CREATE INDEX authcor_user_id
    ON authcor (user_id);
CREATE INDEX authcor_group_id
    ON authcor (group_id);
CREATE INDEX authcor_dest_group_id
    ON authcor (dest_group_id);

CREATE TABLE issuedhash
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    clienthost TEXT,
    hash       TEXT,
    expired    DateTime
);

CREATE UNIQUE INDEX issuedhash_id
    ON issuedhash (id);
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
CREATE UNIQUE INDEX operationlog_id
    ON operationlog (id);
