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

DROP VIEW IF EXISTS detail_calc;
CREATE VIEW detail_calc AS
SELECT detail_id,
       detail.account_id,
       detail.description  AS description,
       unit_price,
       qty,
       detail.tax_rate     AS tax_rate,
       tax_kind, /* 0=内税, 1=外税 */
       issued_date,
       account.description AS account_description,
       account.tax_rate    AS tax_rate_account,
       account.debit_id, /* 借方コード */
       debit_item.item_name,
       debit_item.alloc_rate, /* 組み込み比率 */
       detail.`delete`     AS `delete`,
       unit_price * qty * debit_item.alloc_rate
           * CASE detail.tax_rate > 0
                 WHEN TRUE THEN
                     CASE tax_kind
                         WHEN 0 THEN 1
                         WHEN 1 THEN 1 + detail.tax_rate
                         ELSE 1 END
                 ELSE
                     CASE tax_kind
                         WHEN 0 THEN 1
                         WHEN 1 THEN 1 + account.tax_rate
                         ELSE 1 END
           END             AS item_price,
       unit_price * qty * debit_item.alloc_rate
           * CASE detail.tax_rate > 0
                 WHEN TRUE THEN
                     CASE tax_kind
                         WHEN 0 THEN detail.tax_rate / (1 + detail.tax_rate)
                         WHEN 1 THEN detail.tax_rate
                         ELSE 0 END
                 ELSE
                     CASE tax_kind
                         WHEN 0 THEN account.tax_rate / (1 + account.tax_rate)
                         WHEN 1 THEN account.tax_rate
                         ELSE 0 END
           END             AS tax_price,
       unit_price * qty * debit_item.alloc_rate
           * CASE detail.tax_rate > 0
                 WHEN TRUE THEN
                     CASE tax_kind
                         WHEN 0 THEN 1 / (1 + detail.tax_rate)
                         WHEN 1 THEN 1
                         ELSE 1 END
                 ELSE
                     CASE tax_kind
                         WHEN 0 THEN 1 / (1 + account.tax_rate)
                         WHEN 1 THEN 1
                         ELSE 1 END
           END             AS net_price
FROM detail
         INNER JOIN account ON detail.account_id = account.account_id
         LEFT JOIN item AS debit_item ON debit_item.item_id = account.debit_id
;
DROP VIEW IF EXISTS account_calc;
CREATE VIEW account_calc AS
SELECT account.account_id,
       ROUND(SUM(detail_calc.item_price)) AS item_total,
       ROUND(SUM(detail_calc.net_price))  AS net_total,
       ROUND(SUM(detail_calc.tax_price))  AS tax_total
FROM account
         INNER JOIN detail_calc ON detail_calc.account_id = account.account_id
WHERE (account.`delete` <> '1'
    OR account.`delete` IS NULL)
  AND (detail_calc.`delete` <> '1'
    OR detail_calc.`delete` IS NULL)
GROUP BY account.account_id
;
DROP VIEW IF EXISTS parent_calc;
CREATE VIEW parent_calc AS
SELECT account.parent_account_id,
       ROUND(SUM(detail_calc.item_price)) AS item_total,
       ROUND(SUM(detail_calc.net_price))  AS net_total,
       ROUND(SUM(detail_calc.tax_price))  AS tax_total
FROM account
         INNER JOIN detail_calc ON detail_calc.account_id = account.account_id
WHERE account.`delete` <> '1'
   OR account.`delete` IS NULL
    AND (detail_calc.`delete` <> '1'
        OR detail_calc.`delete` IS NULL)
GROUP BY account.parent_account_id
;
DROP VIEW IF EXISTS account_list;
CREATE VIEW account_list AS
SELECT account.account_id,
       account.parent_account_id,
       DATE_FORMAT(account.issued_date, '%Y-%m')                                 AS ym,
       DATE_FORMAT(account.issued_date, '%Y')                                    AS y,
       parent_calc.item_total                                                    AS parent_total,
       account_calc.item_total                                                   AS item_total,
       account_calc.net_total                                                    AS net_total,
       account_calc.tax_total                                                    AS tax_total,
       kind, /* 領収書, 請求書 */
       tax_kind, /* 0=内税, 1=外税 */
       CASE tax_kind WHEN "0" THEN '内税' WHEN "1" THEN '外税' ELSE '非課税' END AS kind_str,
       issued_date,
       description,
       memo,
       company_id,
       company,
       `section`,
       person,
       postal_code,
       address,
       title,
       invoice_path,
       tax_rate,
       comment,
       account.debit_id                                                          AS debit_id,
       debit_item.item_name /* 借方コード */                                        AS debit_item_name,
       debit_item.alloc_rate, /* 組み込み比率 */
       debit_item.is_purchase,
       debit_item.is_other_exp,
       account.credit_id /* 貸方コード */                                           AS credit_id,
       credit_item.item_name                                                     AS credit_item_name,
       account.assort_pattern_id /* 仕訳パターン番号 */                              AS assort_pattern_id,
       pattern_name,
       assort_pattern.debit_id /* 借方コード */                                     AS debit_id_assort,
       assort_pattern.credit_id /* 貸方コード */                                    AS credit_id_assort,
       account.`delete`                                                          AS `delete`
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
         LEFT JOIN parent_calc ON account.account_id = parent_calc.parent_account_id
         LEFT JOIN item AS debit_item ON debit_item.item_id = account.debit_id
         LEFT JOIN item AS credit_item ON credit_item.item_id = account.credit_id
         LEFT JOIN assort_pattern ON account.assort_pattern_id = assort_pattern.assort_pattern_id
ORDER BY issued_date
        DESC
;
DROP VIEW IF EXISTS monthly_summary_income;
CREATE VIEW monthly_summary_income AS
SELECT DATE_FORMAT(account.issued_date, '%Y')    AS y,
       DATE_FORMAT(account.issued_date, '%Y-%m') AS ym,
       SUM(account_calc.item_total)              AS item_total,
       SUM(account_calc.net_total)               AS net_total,
       SUM(account_calc.tax_total)               AS tax_total
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
WHERE account.credit_id = 700 /* 700=売上高 */
  AND (`delete` <> '1' OR `delete` IS NULL)
GROUP BY DATE_FORMAT(account.issued_date, '%Y-%m')
;
DROP VIEW IF EXISTS monthly_summary_purchase;
CREATE VIEW monthly_summary_purchase AS
SELECT DATE_FORMAT(account.issued_date, '%Y-%m') AS ym,
       SUM(account_calc.item_total)              AS item_total,
       SUM(account_calc.net_total)               AS net_total,
       SUM(account_calc.tax_total)               AS tax_total
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
         LEFT JOIN item ON item.item_id = account.debit_id
WHERE item.is_purchase = 1
  AND (`delete` <> '1' OR `delete` IS NULL)
GROUP BY DATE_FORMAT(account.issued_date, '%Y-%m')
;
DROP VIEW IF EXISTS monthly_summary_others;
CREATE VIEW monthly_summary_others AS
SELECT DATE_FORMAT(account.issued_date, '%Y-%m') AS ym,
       SUM(account_calc.item_total)              AS item_total,
       SUM(account_calc.net_total)               AS net_total,
       SUM(account_calc.tax_total)               AS tax_total
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
         LEFT JOIN item ON item.item_id = account.debit_id
WHERE item.is_other_exp = 1
  AND (`delete` <> '1' OR `delete` IS NULL)
GROUP BY DATE_FORMAT(account.issued_date, '%Y-%m')
;
DROP VIEW IF EXISTS monthly_summary;
CREATE VIEW monthly_summary AS
SELECT monthly_summary_income.y            AS y,
       monthly_summary_income.ym           AS ym,
       monthly_summary_income.item_total   AS income_item_total,
       monthly_summary_income.net_total    AS income_net_total,
       monthly_summary_income.tax_total    AS income_tax_total,
       monthly_summary_purchase.item_total AS purchase_item_total,
       monthly_summary_purchase.net_total  AS purchase_net_total,
       monthly_summary_purchase.tax_total  AS purchase_tax_total,
       monthly_summary_others.item_total   AS others_item_total,
       monthly_summary_others.net_total    AS others_net_total,
       monthly_summary_others.tax_total    AS others_tax_total
FROM monthly_summary_income
         LEFT JOIN monthly_summary_purchase ON monthly_summary_income.ym = monthly_summary_purchase.ym
         LEFT JOIN monthly_summary_others ON monthly_summary_income.ym = monthly_summary_others.ym
ORDER BY ym DESC
;
DROP VIEW IF EXISTS item_summary_debit;
CREATE VIEW item_summary_debit AS
SELECT DATE_FORMAT(account.issued_date, '%Y') AS y,
       debit_id,
       item.item_name                         AS item_name,
       SUM(account_calc.item_total)           AS item_total,
       SUM(account_calc.net_total)            AS net_total,
       SUM(account_calc.tax_total)            AS tax_total
FROM account
         LEFT JOIN item ON item.item_id = account.debit_id
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
WHERE `delete` <> '1'
   OR `delete` IS NULL
GROUP BY DATE_FORMAT(account.issued_date, '%Y'), debit_id
;
DROP VIEW IF EXISTS item_summary_credit;
CREATE VIEW item_summary_credit AS
SELECT DATE_FORMAT(account.issued_date, '%Y') AS y,
       credit_id,
       item.item_name                         AS item_name,
       SUM(account_calc.item_total)           AS item_total,
       SUM(account_calc.net_total)            AS net_total,
       SUM(account_calc.tax_total)            AS tax_total
FROM account
         LEFT JOIN item ON item.item_id = account.credit_id
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
WHERE `delete` <> '1'
   OR `delete` IS NULL
GROUP BY DATE_FORMAT(account.issued_date, '%Y'), credit_id
;
DROP VIEW IF EXISTS years;
CREATE VIEW years AS
SELECT `year`
FROM fiscal_year
WHERE `year` <= DATE_FORMAT(CURDATE(), '%Y')
  AND `year` > DATE_FORMAT(CURDATE(), '%Y') - 3
ORDER BY `year` DESC
;

/*
 operationlog table example

sqlite> select id,dt,user,access,context,key_value,edit_field,edit_value from operationlog order by dt desc limit 5;
744|2022-04-12 09:35:49||delete|detail_list|21845||
743|2022-04-12 09:35:46||create|detail_list|13742|account_id|13742
742|2022-04-12 09:28:34||update|detail_list|21765|qty|3

 */
/*
DROP VIEW IF EXISTS editlog_account;
CREATE VIEW item_summary_credit AS
SELECT id,
      dt,
      user,
      access,
      context,
      key_value,
      edit_field,
      edit_value
FROM operationlog
order by dt desc
;
DROP VIEW IF EXISTS editlog_detail;
CREATE VIEW item_summary_credit AS
SELECT id,
      dt,
      user,
      access,
      context,
      key_value,
      edit_field,
      edit_value
FROM operationlog
order by dt desc
;
*/

INSERT INTO authuser(id, username, hashedpasswd)
VALUES (1, 'account', '24a53d4379c9313b192d5af524ccfa814087d3187844e1154611d2a8ecfc652e6d48555a'); /* Leyc291#B */

INSERT INTO item
VALUES (1, '帳簿外', 0.0, 1, 0, 0);
INSERT INTO item
VALUES (2, '【要選択】', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (100, '現金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (110, '当座預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (115, '普通預金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (117, '普通預金_個人口座', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (120, '通知預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (124, '定期預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (128, '定期積金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (130, '諸口預金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (140, '受取手形', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (141, '売掛金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (150, '有価証券', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (160, '商品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (161, '製品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (162, '半製品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (163, '仕掛品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (164, '原材料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (165, '貯蔵品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (166, '積送品', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (170, '前渡金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (171, '立替金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (172, '未収入金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (174, '預け金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (175, '前払費用', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (176, '仮払金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (180, '仮払消費税', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (181, '事業主借', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (199, '貸倒引当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (200, '建物', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (203, '機械装置', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (204, '車両運搬具', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (205, '建物及附属設備', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (206, '工具器具備品', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (210, '土地', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (232, '建物賃借権', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (240, '投資有価証券', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (241, '出資金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (242, '敷金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (243, '保証金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (246, '入会金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (247, '権利金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (250, '保険積立', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (260, '開業費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (261, '開発費', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (262, '試験研究費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (264, '新株発行費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (400, '支払手形', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (403, '元入金', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (404, '事業主貸', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (405, '買掛金', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (406, '未払外注費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (407, '未払費用', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (410, '短期借入金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (420, '未払金', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (423, '専従者給与', 1.0, 1, NULL, 0);
INSERT INTO item
VALUES (426, '預り金', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (427, '仮受金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (428, '前受金', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (430, '割引手形', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (440, '仮受消費税', 1.0, NULL, 0, 0);
INSERT INTO item
VALUES (450, '賞与引当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (452, '返品調整引当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (610, '材料仕入高', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (618, '仕入値引', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (625, '仕入高', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (640, '役員報酬', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (641, '給与手当', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (642, '賞与', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (643, '退職金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (644, '雑給', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (645, '法定福利費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (646, '福利厚生費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (647, '賞与引当金繰入', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (648, '退職金共済掛金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (650, '外注加工費', 1.0, 0, 1, 0);
INSERT INTO item
VALUES (651, '荷造発送費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (652, '広告宣伝費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (653, '交際費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (654, '会議費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (655, '旅費交通費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (656, '通信費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (657, '積送諸掛費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (658, '車輌費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (659, 'ソフト費', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (660, '消耗品費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (661, '事務用品費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (662, '修繕費', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (663, '水道光熱費', 0.3, 1, 0, 0);
INSERT INTO item
VALUES (664, '新聞図書費', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (665, '諸会費', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (666, '支払手数料', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (667, '医療費', 0.0, 0, 0, 0);
INSERT INTO item
VALUES (669, '通信インフラ', 1.0, 1, 1, 0);
INSERT INTO item
VALUES (670, '支払保険料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (671, '支払報酬', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (672, '寄付金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (680, '減価償却', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (681, '地代家賃', 0.3, 0, 0, 0);
INSERT INTO item
VALUES (682, 'リース料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (683, '租税公課', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (686, '貸倒損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (687, '開発費償却', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (689, '雑費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (700, '売上高', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (709, '売上値引', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (720, '期首棚卸高', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (725, '仕入高', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (726, '内部仕入れ', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (729, '仕入値引', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (741, '給与手当', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (746, '福利厚生費', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (775, '貸倒引当金繰入', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (779, '少額減価償却資産', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (780, '一括償却資産', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (781, '地代家賃', 0.3, 1, 0, 0);
INSERT INTO item
VALUES (782, 'リース料', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (783, '租税公課', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (786, '貸倒損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (800, '受取利息', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (801, '受取配当金', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (802, '有価証券利息', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (816, '雑収入', 1.0, 1, 0, 0);
INSERT INTO item
VALUES (846, '雑損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (913, 'その他の特別利益', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (933, 'その他の特別損失', 1.0, 0, 0, 0);
INSERT INTO item
VALUES (980, '法人税等', 1.0, 1, 0, 0);

INSERT INTO assort_pattern
VALUES (1, '現金で購入', 2, 181);
INSERT INTO assort_pattern
VALUES (2, '現金を引き出し', 100, 115);
INSERT INTO assort_pattern
VALUES (3, '現金での報酬', 100, 700);
INSERT INTO assort_pattern
VALUES (4, '振り込み（請求書あり）', 115, 141);
INSERT INTO assort_pattern
VALUES (5, '振り込み（請求書なし）', 115, 700);
INSERT INTO assort_pattern
VALUES (6, '引き落とし・支払い', 2, 115);
INSERT INTO assort_pattern
VALUES (7, 'クレジット購入', 2, 405);
INSERT INTO assort_pattern
VALUES (8, '請求した', 141, 700);
INSERT INTO assort_pattern
VALUES (9, 'クレジットの支払い', 405, 115);
INSERT INTO assort_pattern
VALUES (10, '請求された', 2, 405);
INSERT INTO assort_pattern
VALUES (11, '請求に対する支払', 405, 115);
INSERT INTO assort_pattern
VALUES (12, '源泉徴収（振り込み時）', 404, 115);
INSERT INTO assort_pattern
VALUES (13, '減価償却', 680, 206);
INSERT INTO assort_pattern
VALUES (14, '見積もり', 2, 2);
INSERT INTO assort_pattern
VALUES (15, '帳簿外', 1, 1);
INSERT INTO assort_pattern
VALUES (16, '個人用をクレジット購入', 404, 405);
INSERT INTO assort_pattern
VALUES (17, '個人のクレジットで購入', 2, 181);
INSERT INTO assort_pattern
VALUES (18, '個人のクレジット支払い', 1, 1);
INSERT INTO assort_pattern
VALUES (19, '振り込み個人口座（請求書あり）', 404, 141);
INSERT INTO assort_pattern
VALUES (20, '振り込み個人口座（請求書なし）', 404, 700);
INSERT INTO assort_pattern
VALUES (21, '引き落とし・支払い個人口座', 2, 181);

INSERT INTO fiscal_year(year)
VALUES (2020);
INSERT INTO fiscal_year(year)
VALUES (2021);
INSERT INTO fiscal_year(year)
VALUES (2022);
INSERT INTO fiscal_year(year)
VALUES (2023);
INSERT INTO fiscal_year(year)
VALUES (2024);
INSERT INTO fiscal_year(year)
VALUES (2025);
INSERT INTO fiscal_year(year)
VALUES (2026);
INSERT INTO fiscal_year(year)
VALUES (2027);
INSERT INTO fiscal_year(year)
VALUES (2028);
INSERT INTO fiscal_year(year)
VALUES (2029);
INSERT INTO fiscal_year(year)
VALUES (2030);
INSERT INTO fiscal_year(year)
VALUES (2031);
INSERT INTO fiscal_year(year)
VALUES (2032);
INSERT INTO fiscal_year(year)
VALUES (2033);
INSERT INTO fiscal_year(year)
VALUES (2034);

INSERT INTO company(company, section, person, postal_code, address)
VALUES ('会社1', '部署1', '担当者名1', '999-9999', '東京都埼玉区都会町345-678 大都会ビル12F');
INSERT INTO company(company, section, person, postal_code, address)
VALUES ('会社2', '部署2', '担当者名2', '999-9999', '東京都埼玉区都会町345-678 大都会ビル11F');

INSERT INTO preference(myself, bank_info, show_tax_detail)
VALUES ('○○○○<br>〒999-9999 さいたま市青区大都会1-2-3<br>048-199-1999(tel/fax)<br>msyk@msyk.net',
        '以下の銀行口座に振込をお願いします。<br><br>みずほ銀行（0001）南浦和支店（306）<br>口座番号：9999999<br>名義：○○○○（○○○○）',
        0);