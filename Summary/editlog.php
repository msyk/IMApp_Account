<?php
/**
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt
 *
 * @copyright     Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * @link          https://inter-mediator.com/
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */

require_once '../vendor/inter-mediator/inter-mediator/INTER-Mediator.php';

IM_Entry(
    [
        [
            'name' => 'account_list',
            'table' => 'account',
            'key' => 'account_id',
            'records' => 200,
            'maxrecords' => 100000,
            'paging' => true,
//            'soft-delete' => true,
//            'default-values' => [
//                ['field' => 'issued_date', 'value' => IM_TODAY],
//                ['field' => 'debit_id', 'value' => 2],
//                ['field' => 'credit_id', 'value' => 2],
//                ['field' => 'invoice_path', 'value' => ""],
//            ],
            //'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
            //'repeat-control' => 'confirm-insert confirm-delete confirm-copy-detail_list',
            'navi-control' => 'master-hide',
            //'button-names' => ['insert' => '新規会計項目作成'],
            'calculation' => [
                ['field' => "attached", 'expression' => "if(invoice_path='','','証票有')",],
                ['field' => "deleteStyle", 'expression' => "if(delete,'pink','')",],
            ],
            'numeric-fields' => ['item_total'],
        ],
        [
            'name' => 'account_detail',
            'view' => 'account_list',
            'table' => 'account',
            'key' => 'account_id',
            'records' => 1,
//            'soft-delete' => true,
            'navi-control' => 'detail',
            'calculation' => [
                ['field' => "item_total_calc", 'expression' => "sum(detail_list@item_price_calc)",],
                ['field' => "tax_total_calc", 'expression' => "sum(detail_list@tax_price_calc)",],
                ['field' => "net_total_calc", 'expression' => "sum(detail_list@net_price_calc)",],
                ['field' => "s3_style", 'expression' => "if(invoice_path,'inline','none')",],
            ],
        ],
        [
            'name' => 'detail_list',
            'view' => 'detail_calc',
            'table' => 'detail',
            'key' => 'detail_id',
            'records' => 100000,
            'maxrecords' => 100000,
//            'soft-delete' => true,
//            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
            'relation' => [['foreign-key' => 'account_id', 'join-field' => 'account_id', 'operator' => '='],],
            'sort' => [['field' => 'detail_id', 'direction' => 'asc',],],
            'calculation' => [
                ['field' => "item_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),1,1 + tax_rate,1),choice(abs(account_detail@tax_kind+0),1,1 + account_detail@tax_rate,1))",],
                ['field' => "tax_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),tax_rate/(1 + tax_rate),tax_rate,0),choice(abs(account_detail@tax_kind+0),account_detail@tax_rate/(1 + account_detail@tax_rate),account_detail@tax_rate,0))",],
                ['field' => "net_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),1/(1 + tax_rate),1,1),choice(abs(account_detail@tax_kind+0),1/(1 + account_detail@tax_rate),1,1))",],
                ['field' => "deleteStyle", 'expression' => "if(delete,'pink','')",],
            ],
        ],
        [
            'name' => 'operationlog_account',
            'view' => 'operationlog',
            'key' => 'id',
            'records' => 100000,
            'maxrecords' => 100000,
            'query' => [
                ['field' => 'context', 'value' => 'account_list', 'operator' => '='],
                ['field' => 'context', 'value' => 'account_detail', 'operator' => '='],
                ['field' => 'context', 'value' => 'account_add', 'operator' => '='],
                ['field' => '__operation__', 'operator' => 'ex',],
            ],
            'relation' => [['foreign-key' => 'key_value', 'join-field' => 'account_id', 'operator' => '='],],
            'sort' => [['field' => 'dt', 'direction' => 'asc',], ['field' => 'id', 'direction' => 'asc',],],
        ],
        [
            'name' => 'operationlog_detail',
            'view' => 'operationlog',
            'key' => 'id',
            'records' => 100000,
            'maxrecords' => 100000,
            'query' => [
                ['field' => 'context', 'value' => 'detail_list', 'operator' => '='],
                ['field' => 'context', 'value' => 'detail_add', 'operator' => '='],
                ['field' => '__operation__', 'operator' => 'ex',],
            ],
            'relation' => [['foreign-key' => 'key_value', 'join-field' => 'detail_id', 'operator' => '='],],
            'sort' => [['field' => 'dt', 'direction' => 'asc',], ['field' => 'id', 'direction' => 'asc',],],
        ],
    ],
    [
//        'authentication' => [
//            'authexpired' => '7200',
//            'storing' => 'credential',
//        ],

    ],
    ['db-class' => 'PDO',],
    2
);

