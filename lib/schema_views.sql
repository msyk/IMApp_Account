DROP VIEW detail_calc;
CREATE VIEW detail_calc AS
SELECT detail_id,
       detail.account_id,
       detail.description  AS description,
       unit_price,
       qty,
       detail.tax_rate,
       tax_kind, /* 0=内税, 1=外税 */
       issued_date,
       account.description AS account_description,
       account.tax_rate,
       account.debit_id, /* 借方コード */
       debit_item.item_name,
       debit_item.alloc_rate, /* 組み込み比率 */
       unit_price * qty * debit_item.alloc_rate
           * IIF(detail.tax_rate > 0,
                 CASE tax_kind
                     WHEN 0 THEN 1
                     WHEN 1 THEN 1 + detail.tax_rate
                     ELSE 1 END,
                 CASE tax_kind
                     WHEN 0 THEN 1
                     WHEN 1 THEN 1 + account.tax_rate
                     ELSE 1 END)
                           AS item_price,
       unit_price * qty * debit_item.alloc_rate
           * IIF(detail.tax_rate > 0,
                 CASE tax_kind
                     WHEN 0 THEN detail.tax_rate / (1 + detail.tax_rate)
                     WHEN 1 THEN detail.tax_rate
                     ELSE 0 END,
                 CASE tax_kind
                     WHEN 0 THEN account.tax_rate / (1 + account.tax_rate)
                     WHEN 1 THEN account.tax_rate
                     ELSE 0 END)
                           AS tax_price,
       unit_price * qty * debit_item.alloc_rate
           * IIF(detail.tax_rate > 0,
                 CASE tax_kind
                     WHEN 0 THEN 1 / (1 + detail.tax_rate)
                     WHEN 1 THEN 1
                     ELSE 1 END,
                 CASE tax_kind
                     WHEN 0 THEN 1 / (1 + account.tax_rate)
                     WHEN 1 THEN 1
                     ELSE 1 END)
                           AS net_price
FROM detail
         INNER JOIN account ON detail.account_id = account.account_id
         LEFT JOIN item AS debit_item ON debit_item.item_id = account.debit_id
;
DROP VIEW account_calc;
CREATE VIEW account_calc AS
SELECT account.account_id,
       SUM(detail_calc.item_price) AS item_total,
       SUM(detail_calc.net_price)  AS net_total,
       SUM(detail_calc.tax_price)  AS tax_total
FROM account
         INNER JOIN detail_calc ON detail_calc.account_id = account.account_id
GROUP BY account.account_id
;
DROP VIEW parent_calc;
CREATE VIEW parent_calc AS
SELECT account.parent_account_id,
       SUM(detail_calc.item_price) AS item_total,
       SUM(detail_calc.net_price)  AS net_total,
       SUM(detail_calc.tax_price)  AS tax_total
FROM account
         INNER JOIN detail_calc ON detail_calc.account_id = account.account_id
GROUP BY account.parent_account_id
;
DROP VIEW account_list;
CREATE VIEW account_list AS
SELECT account.account_id,
       account.parent_account_id,
       parent_calc.item_total                                             AS parent_total,
       account_calc.item_total                                            AS item_total,
       account_calc.net_total                                             AS net_total,
       account_calc.tax_total                                             AS tax_total,
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
       account.debit_id, /* 借方コード */
       debit_item.item_name                                               AS debit_item_name,
       debit_item.alloc_rate, /* 組み込み比率 */
       account.credit_id, /* 貸方コード */
       credit_item.item_name                                              AS credit_item_name,
       account.assort_pattern_id                                          AS assort_pattern_id, /* 仕分けパターン番号 */
       pattern_name,
       assort_pattern.debit_id, /* 借方コード */
       assort_pattern.credit_id /* 貸方コード */
FROM account
         LEFT JOIN account_calc ON account.account_id = account_calc.account_id
         LEFT JOIN parent_calc ON account.account_id = parent_calc.parent_account_id
         LEFT JOIN item AS debit_item ON debit_item.item_id = account.debit_id
         LEFT JOIN item AS credit_item ON credit_item.item_id = account.credit_id
         LEFT JOIN assort_pattern ON account.assort_pattern_id = assort_pattern.assort_pattern_id
ORDER BY issued_date DESC
;
