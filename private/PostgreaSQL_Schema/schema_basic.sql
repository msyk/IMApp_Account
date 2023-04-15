/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

This schema file is for the sample of INTER-Mediator using PostgreSQL, encoded by UTF-8.

Example:
$ psql -c 'create database imapp_account;' -h localhost postgres
$ psql -f schema_basic.sql -h localhost imapp_account
$ psql -f schema_views.sql -h localhost imapp_account
$ psql -f schema_initial_data.sql -h localhost imapp_account
*/
DROP USER IF EXISTS web;
CREATE USER web PASSWORD 'password';
DROP SCHEMA IF EXISTS imapp_account CASCADE;
CREATE SCHEMA imapp_account;
SET search_path TO imapp_account,public;
ALTER USER web SET search_path TO imapp_account,public;

GRANT ALL PRIVILEGES ON SCHEMA imapp_account TO web;

CREATE TABLE account
(
    account_id        SERIAL PRIMARY KEY,
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
    comment           TEXT,
    tax_rate          REAL    DEFAULT 0.1,
    debit_id          INTEGER, /* 借方コード */
    credit_id         INTEGER, /* 貸方コード */
    assort_pattern_id INTEGER, /* 仕訳パターン番号 */
    "delete"          INTEGER
);

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
CREATE INDEX account_delete
    ON account ("delete");

CREATE TABLE detail
(
    detail_id   SERIAL PRIMARY KEY,
    account_id  INTEGER,
    description TEXT,
    unit_price  REAL NOT NULL,
    qty         REAL NOT NULL,
    tax_rate    REAL,
    "delete"    INTEGER
);

CREATE INDEX detail_account_id
    ON detail (account_id);
CREATE INDEX detail_delete
    ON detail ("delete");

CREATE TABLE item
(
    item_id      INTEGER PRIMARY KEY,
    item_name    TEXT,
    alloc_rate   REAL, /* 組み込み比率 */
    "show"       INTEGER, /* 1=ポップアップ表示 */
    is_purchase  INTEGER, /* 仕入れに入れる項目 */
    is_other_exp INTEGER /* 仕入れに入れない経費項目 */
);

CREATE TABLE assort_pattern
(
    assort_pattern_id SERIAL PRIMARY KEY, /* 仕訳パターン番号 */
    pattern_name      TEXT,
    debit_id          INTEGER, /* 借方コード */
    credit_id         INTEGER /* 貸方コード */
);

CREATE TABLE fiscal_year
(
    year INTEGER PRIMARY KEY
);

CREATE TABLE company
(
    company_id  SERIAL PRIMARY KEY,
    company     TEXT,
    section     TEXT,
    person      TEXT,
    postal_code TEXT,
    address     TEXT
);

CREATE TABLE preference
(
    preference_id   SERIAL PRIMARY KEY,
    myself          TEXT,
    bank_info       TEXT,
    show_tax_detail INTEGER DEFAULT 0 NOT NULL,
    show_label      INTEGER DEFAULT 1 NOT NULL,
    sender_info     TEXT,
    copy_detail     INTEGER DEFAULT 0 NOT NULL
);
/* Observable */
CREATE TABLE registeredcontext
(
    id           SERIAL PRIMARY KEY,
    clientid     TEXT,
    entity       TEXT,
    conditions   TEXT,
    registereddt TIMESTAMP
);

CREATE TABLE registeredpks
(
    context_id INTEGER,
    pk         INTEGER,
    PRIMARY KEY (context_id, pk),
    FOREIGN KEY (context_id) REFERENCES registeredcontext (id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX registeredpks_context_id
    ON registeredpks (context_id);
CREATE INDEX registeredpks_pk
    ON registeredpks (pk);


CREATE TABLE authuser
(
    id           SERIAL PRIMARY KEY,
    username     TEXT,
    hashedpasswd TEXT,
    email        TEXT,
    realname     VARCHAR(20),
    limitdt      TIMESTAMP
);

CREATE INDEX authuser_username
    ON authuser (username);
CREATE INDEX authuser_email
    ON authuser (email);
CREATE INDEX authuser_limitdt
    ON authuser (limitdt);

CREATE TABLE authgroup
(
    id        SERIAL PRIMARY KEY,
    groupname TEXT
);

CREATE TABLE authcor
(
    id            SERIAL PRIMARY KEY,
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

CREATE TABLE issuedhash
(
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER,
    clienthost TEXT,
    hash       TEXT,
    expired    TIMESTAMP
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
    id            SERIAL PRIMARY KEY,
    dt            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "user"        VARCHAR(48),
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
    error         TEXT,
    key_value     INTEGER,
    edit_field    VARCHAR(20),
    edit_value    TEXT
);
