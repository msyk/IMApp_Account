<?php

use \INTERMediator\DB\Proxy;

class AccountCSV
{
    private $keysAndLabels = [
        "account_id" => "管理番号",
        "parent_account_id" => "関連項目管理番号",
        "parent_total" => "関連項目合計金額",
        "item_total" => "合計金額",
        "net_total" => "税抜金額",
        "tax_total" => "消費税額",
        "kind" => "書類名",
        "tax_kind" => "税区分コード",
        "kind_str" => "税区分",
        "issued_date" => "日付",
        "description" => "説明",
        "memo" => "メモ",
        "company_id" => "会社マスタID",
        "company" => "会社名",
        "section" => "部署名",
        "person" => "担当者名",
        "postal_code" => "郵便番号",
        "address" => "住所",
        "invoice_path" => "ファイルパス",
        "tax_rate" => "消費税率",
        "debit_id" => "借方科目コード",
        "debit_item_name" => "借方科目",
        "alloc_rate" => "借方科目組入比率",
        "is_purchase" => "借方科目仕入れ",
        "credit_id" => "貸方科目コード",
        "credit_item_name" => "貸方科目",
        "assort_pattern_id" => "仕分けコード",
        "pattern_name" => "仕分けパターン",
    ];

    public function processing($contextData, $options)
    {
        $qH = '"'; // ヘッダで使うダブルクォート
        $q = '"';
        $sp =',';

        header('Content-Type: data:application/octet-stream');
        $filename = "IMAccount-" . (new DateTime())->format('Ymd') . ".csv";
        header("Content-Disposition: attachment; filename={$qH}{$filename}{$qH}");

        $dataArray = [];
        foreach (array_values($this->keysAndLabels) as $fieldName) {
            $dataArray[] = $fieldName;
        }
        echo "{$q}" . mb_convert_encoding(implode("{$q}{$sp}{$q}", $dataArray), "UTF-8") . "{$q}\n";

        $fieldArray = array_keys($this->keysAndLabels);
        foreach ($contextData as $record) {
            $dataArray = [];
            foreach ($fieldArray as $field) {
                $dataArray[] = $record[$field];
            }
            $line = str_replace("<br>", "+",
                "{$q}" . mb_convert_encoding(implode("{$q}{$sp}{$q}", $dataArray), 'UTF-8') . "{$q}"
            );
            $line = str_replace("\n", "/",
                str_replace("\r", "/",
                    str_replace("\r\n", "/", $line)));
            echo $line . "\n";
        }
    }
}
