SET search_path TO imapp_account,public;

CREATE OR REPLACE VIEW detail_calc AS
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
       detail."delete"     AS "delete",
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
CREATE OR REPLACE VIEW account_calc AS
SELECT account.account_id,
       ROUND(SUM(detail_calc.item_price)) AS item_total,
       ROUND(SUM(detail_calc.net_price))  AS net_total,
       ROUND(SUM(detail_calc.tax_price))  AS tax_total
FROM account
         INNER JOIN detail_calc ON detail_calc.account_id = account.account_id
WHERE (account."delete" <> '1'
    OR account."delete" IS NULL)
  AND (detail_calc."delete" <> '1'
    OR detail_calc."delete" IS NULL)
GROUP BY account.account_id
;
CREATE OR REPLACE VIEW parent_calc AS
SELECT account.parent_account_id,
       ROUND(SUM(detail_calc.item_price)) AS item_total,
       ROUND(SUM(detail_calc.net_price))  AS net_total,
       ROUND(SUM(detail_calc.tax_price))  AS tax_total
FROM account
         INNER JOIN detail_calc ON detail_calc.account_id = account.account_id
WHERE account."delete" <> '1'
   OR account."delete" IS NULL
    AND (detail_calc."delete" <> '1'
        OR detail_calc."delete" IS NULL)
GROUP BY account.parent_account_id
;
CREATE OR REPLACE VIEW account_list AS
SELECT account.account_id,
       account.parent_account_id,
       TO_CHAR(account.issued_date, 'YYYY-MM')                               AS ym,
       TO_CHAR(account.issued_date, 'YYYY')                                  AS y,
       parent_calc.item_total                                                AS parent_total,
       account_calc.item_total                                               AS item_total,
       account_calc.net_total                                                AS net_total,
       account_calc.tax_total                                                AS tax_total,
       kind, /* 領収書, 請求書 */
       tax_kind, /* 0=内税, 1=外税 */
       CASE tax_kind WHEN 0 THEN '内税' WHEN 1 THEN '外税' ELSE '非課税' END AS kind_str,
       issued_date,
       description,
       memo,
       company_id,
       company,
       "section",
       person,
       postal_code,
       address,
       title,
       invoice_path,
       tax_rate,
       comment,
       account.debit_id                                                      AS debit_id,
       debit_item.item_name /* 借方コード */                                    AS debit_item_name,
       debit_item.alloc_rate, /* 組み込み比率 */
       debit_item.is_purchase,
       debit_item.is_other_exp,
       account.credit_id /* 貸方コード */                                       AS credit_id,
       credit_item.item_name                                                 AS credit_item_name,
       account.assort_pattern_id /* 仕訳パターン番号 */                          AS assort_pattern_id,
       pattern_name,
       assort_pattern.debit_id /* 借方コード */                                 AS debit_id_assort,
       assort_pattern.credit_id /* 貸方コード */                                AS credit_id_assort,
       account."delete"                                                      AS "delete"
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
         LEFT JOIN parent_calc ON account.account_id = parent_calc.parent_account_id
         LEFT JOIN item AS debit_item ON debit_item.item_id = account.debit_id
         LEFT JOIN item AS credit_item ON credit_item.item_id = account.credit_id
         LEFT JOIN assort_pattern ON account.assort_pattern_id = assort_pattern.assort_pattern_id
ORDER BY issued_date
        DESC
;
CREATE OR REPLACE VIEW monthly_summary_income AS
SELECT TO_CHAR(account.issued_date, 'YYYY')    AS y,
       TO_CHAR(account.issued_date, 'YYYY-MM') AS ym,
       SUM(account_calc.item_total)            AS item_total,
       SUM(account_calc.net_total)             AS net_total,
       SUM(account_calc.tax_total)             AS tax_total
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
WHERE account.credit_id = 700 /* 700=売上高 */
  AND ("delete" <> '1' OR "delete" IS NULL)
GROUP BY TO_CHAR(account.issued_date, 'YYYY'), TO_CHAR(account.issued_date, 'YYYY-MM')
;
CREATE OR REPLACE VIEW monthly_summary_purchase AS
SELECT TO_CHAR(account.issued_date, 'YYYY-MM') AS ym,
       SUM(account_calc.item_total)            AS item_total,
       SUM(account_calc.net_total)             AS net_total,
       SUM(account_calc.tax_total)             AS tax_total
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
         LEFT JOIN item ON item.item_id = account.debit_id
WHERE item.is_purchase = 1
  AND ("delete" <> '1' OR "delete" IS NULL)
GROUP BY TO_CHAR(account.issued_date, 'YYYY-MM')
;
CREATE OR REPLACE VIEW monthly_summary_others AS
SELECT TO_CHAR(account.issued_date, 'YYYY-MM') AS ym,
       SUM(account_calc.item_total)            AS item_total,
       SUM(account_calc.net_total)             AS net_total,
       SUM(account_calc.tax_total)             AS tax_total
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
         LEFT JOIN item ON item.item_id = account.debit_id
WHERE item.is_other_exp = 1
  AND ("delete" <> '1' OR "delete" IS NULL)
GROUP BY TO_CHAR(account.issued_date, 'YYYY-MM')
;
CREATE OR REPLACE VIEW monthly_summary AS
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
CREATE OR REPLACE VIEW item_summary_debit AS
SELECT TO_CHAR(account.issued_date, 'YYYY') AS y,
       debit_id,
       item.item_name                       AS item_name,
       SUM(account_calc.item_total)         AS item_total,
       SUM(account_calc.net_total)          AS net_total,
       SUM(account_calc.tax_total)          AS tax_total
FROM account
         LEFT JOIN item ON item.item_id = account.debit_id
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
WHERE "delete" <> '1'
   OR "delete" IS NULL
GROUP BY TO_CHAR(account.issued_date, 'YYYY'), debit_id, item.item_name
;
CREATE OR REPLACE VIEW item_summary_credit AS
SELECT TO_CHAR(account.issued_date, 'YYYY') AS y,
       credit_id,
       item.item_name                       AS item_name,
       SUM(account_calc.item_total)         AS item_total,
       SUM(account_calc.net_total)          AS net_total,
       SUM(account_calc.tax_total)          AS tax_total
FROM account
         LEFT JOIN item ON item.item_id = account.credit_id
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
WHERE "delete" <> '1'
   OR "delete" IS NULL
GROUP BY TO_CHAR(account.issued_date, 'YYYY'), credit_id, item.item_name
;
CREATE OR REPLACE VIEW years AS
SELECT "year"
FROM fiscal_year
WHERE "year" <= CAST(TO_CHAR(CURRENT_DATE, 'YYYY') as integer)
  AND "year" > CAST(TO_CHAR(CURRENT_DATE, 'YYYY') as integer) - 3
ORDER BY "year" DESC
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
CREATE OR REPLACE VIEW item_summary_credit AS
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
CREATE OR REPLACE VIEW item_summary_credit AS
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