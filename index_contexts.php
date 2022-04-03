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

require_once './vendor/inter-mediator/inter-mediator/INTER-Mediator.php';

IM_Entry(
    [
        [
            'name' => 'account_list',
            'table' => 'account',
            'key' => 'account_id',
            'records' => 200,
            'maxrecords' => 100000,
            'paging' => true,
            'default-values' => [
                ['field' => 'issued_date', 'value' => IM_TODAY],
                ['field' => 'debit_id', 'value' => 2],
                ['field' => 'credit_id', 'value' => 2],
                ['field' => 'invoice_path', 'value' => ""],
            ],
            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
            //'repeat-control' => 'confirm-insert confirm-delete confirm-copy-detail_list',
            //'navi-control' => 'master-hide',
            'button-names' => ['insert' => '新規会計項目作成'],
            'calculation' => [
                ['field' => "attached", 'expression' => "if(invoice_path='','','証票有')",],
                ['field' => "alertStyle", 'expression' => "if(parent_total>0 && round(item_total,0)!=round(parent_total,0),'inline','none')",],
                ['field' => "checkStyle", 'expression' => "if(debit_id=405,'yellow',if(credit_id=141,'papayawhip',if(credit_id=405,'lightyellow',if(debit_id=141,'moccasin',''))))",],
            ],
            'numeric-fields' => ['item_total'],
        ],
        [
            'name' => 'account_all',
            'table' => 'dummy',
            'view' => 'account_list',
            'key' => 'account_id',
            'records' => 100000000,
            'maxrecords' => 100000000,
        ],
        [
            'name' => 'account_detail',
            'view' => 'account_list',
            'table' => 'account',
            'key' => 'account_id',
            'records' => 1,
            //'navi-control' => 'detail-update',
            'calculation' => [
                ['field' => "item_total_calc", 'expression' => "sum(detail_list@item_price_calc)",],
                ['field' => "tax_total_calc", 'expression' => "sum(detail_list@tax_price_calc)",],
                ['field' => "net_total_calc", 'expression' => "sum(detail_list@net_price_calc)",],
                ['field' => "s3_style", 'expression' => "if(invoice_path,'inline','none')",],
            ],
            'file-upload' => [
                ['container' => 'S3',],
            ],
        ],
        [
            'name' => 'detail_list',
            'view' => 'detail_calc',
            'table' => 'detail',
            'key' => 'detail_id',
            'records' => 100000,
            'maxrecords' => 100000,
            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
            'relation' => [['foreign-key' => 'account_id', 'join-field' => 'account_id', 'operator' => '='],],
            'calculation' => [
                ['field' => "item_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),1,1 + tax_rate,1),choice(abs(account_detail@tax_kind+0),1,1 + account_detail@tax_rate,1))",],
                ['field' => "tax_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),tax_rate/(1 + tax_rate),tax_rate,0),choice(abs(account_detail@tax_kind+0),account_detail@tax_rate/(1 + account_detail@tax_rate),account_detail@tax_rate,0))",],
                ['field' => "net_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),1/(1 + tax_rate),1,1),choice(abs(account_detail@tax_kind+0),1/(1 + account_detail@tax_rate),1,1))",],
            ],
        ],
        [
            'name' => 'account_add',
            'view' => 'account',
            'table' => 'account',
            'key' => 'account_id',
            'records' => 100000,
            'maxrecords' => 100000,
        ],
        [
            'name' => 'detail_add',
            'view' => 'detail',
            'table' => 'detail',
            'key' => 'detail_id',
            'records' => 100000,
            'maxrecords' => 100000,
        ],
        [
            'name' => 'assort_pattern',
            'view' => 'assort_pattern',
            'key' => 'assort_pattern_id',
            'records' => 10000,
        ],
        [
            'name' => 'assort_pattern_lookup',
            'view' => 'assort_pattern',
            'key' => 'assort_pattern_id',
            'relation' => [['foreign-key' => 'assort_pattern_id', 'join-field' => 'assort_pattern_id', 'operator' => '=',]]
        ],
        [
            'name' => 'company',
            'view' => 'company',
            'key' => 'company_id',
            'records' => 10000,
        ],
        [
            'name' => 'company_lookup',
            'view' => 'company',
            'key' => 'company_id',
            'relation' => [['foreign-key' => 'company_id', 'join-field' => 'company_id', 'operator' => '=',]]
        ],
        [
            'name' => 'item',
            'key' => 'item_id',
            'query' => [['field' => 'show', 'value' => 1],],
            'sort' => [['field' => 'item_id', 'direction' => 'asc'],],
        ],
        [
            'name' => 'csv_upload',
            'view' => 'detail',
            'table' => 'detail',
            'key' => 'detail_id',
            'records' => 100000,
            'maxrecords' => 100000,
        ],
    ],
    [],
    ['db-class' => 'PDO',],
    2
);
