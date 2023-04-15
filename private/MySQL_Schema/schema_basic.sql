/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

This schema file is for the sample of INTER-Mediator using MySQL, encoded by UTF-8.

Example:
$ mysql -u root -p < schema_basic.sql
Enter password:
mysql -uroot imapp_account < schema_views.sql
mysql -uroot imapp_account < schema_initial_data.sql

*/
SET NAMES 'utf8mb4';

DROP USER IF EXISTS 'web'@'localhost';
CREATE USER 'web'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
######### Moreover add descriptions to the [mysqld] section of any cnf file.
######### default_authentication_plugin = mysql_native_password

# Grant to All operations for all objects with web account
GRANT SELECT, INSERT, DELETE, UPDATE ON TABLE imapp_account.* TO 'web'@'localhost';
GRANT SHOW VIEW ON TABLE imapp_account.* TO 'web'@'localhost';
# For mysqldump, the SHOW VIEW privilege is just required, and use options --single-transaction and --no-tablespaces.

DROP DATABASE IF EXISTS imapp_account;
CREATE DATABASE imapp_account
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE imapp_account;

CREATE TABLE account
(
    account_id        INTEGER PRIMARY KEY AUTO_INCREMENT,
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
    `delete`          INTEGER
);

CREATE INDEX account_parent_account_id
    ON account (parent_account_id);
CREATE INDEX account_issued_date
    ON account (issued_date);
CREATE INDEX account_company
    ON account (company(100));
CREATE INDEX account_description
    ON account (description(100));
CREATE INDEX account_debit_id
    ON account (debit_id);
CREATE INDEX account_credit_id
    ON account (credit_id);
CREATE INDEX account_assort_pattern_id
    ON account (assort_pattern_id);
CREATE INDEX account_delete
    ON account (`delete`);

CREATE TABLE detail
(
    detail_id   INTEGER PRIMARY KEY AUTO_INCREMENT,
    account_id  INTEGER,
    description TEXT,
    unit_price  REAL NOT NULL,
    qty         REAL NOT NULL,
    tax_rate    REAL,
    `delete`    INTEGER
);

CREATE INDEX detail_account_id
    ON detail (account_id);
CREATE INDEX detail_delete
    ON detail (`delete`);

CREATE TABLE item
(
    item_id      INTEGER PRIMARY KEY,
    item_name    TEXT,
    alloc_rate   REAL, /* 組み込み比率 */
    `show`         INTEGER, /* 1=ポップアップ表示 */
    is_purchase  INTEGER, /* 仕入れに入れる項目 */
    is_other_exp INTEGER /* 仕入れに入れない経費項目 */
);

CREATE TABLE assort_pattern
(
    assort_pattern_id INTEGER PRIMARY KEY AUTO_INCREMENT, /* 仕訳パターン番号 */
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
    company_id  INTEGER PRIMARY KEY AUTO_INCREMENT,
    company     TEXT,
    section     TEXT,
    person      TEXT,
    postal_code TEXT,
    address     TEXT
);

CREATE TABLE preference
(
    preference_id   INTEGER PRIMARY KEY AUTO_INCREMENT,
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
    id           INTEGER PRIMARY KEY AUTO_INCREMENT,
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

CREATE UNIQUE INDEX registeredpks_context_id
    ON registeredpks (context_id);
CREATE INDEX registeredpks_pk
    ON registeredpks (pk);


CREATE TABLE authuser
(
    id           INTEGER PRIMARY KEY AUTO_INCREMENT,
    username     TEXT,
    hashedpasswd TEXT,
    email        TEXT,
    realname     VARCHAR(20),
    limitdt      DateTime
);

CREATE INDEX authuser_username
    ON authuser (username(100));
CREATE INDEX authuser_email
    ON authuser (email(100));
CREATE INDEX authuser_limitdt
    ON authuser (limitdt);

CREATE TABLE authgroup
(
    id        INTEGER PRIMARY KEY AUTO_INCREMENT,
    groupname TEXT
);

CREATE TABLE authcor
(
    id            INTEGER PRIMARY KEY AUTO_INCREMENT,
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
    id         INTEGER PRIMARY KEY AUTO_INCREMENT,
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
    ON issuedhash (clienthost(100));
CREATE INDEX issuedhash_user_id_clienthost
    ON issuedhash (user_id, clienthost(100));

/* Operation Log Store */
CREATE TABLE operationlog
(
    id            INTEGER PRIMARY KEY AUTO_INCREMENT,
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
    error         TEXT,
    key_value     INTEGER,
    edit_field    VARCHAR(20),
    edit_value    TEXT
);
