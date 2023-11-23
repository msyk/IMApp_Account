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
            'name' => 'monthly_summary',
            'table' => 'dummy',
            'key' => 'ym',
            'records' => 20,
            'maxrecords' => 100000,
            'paging' => true,
            'soft-delete' => true,
            'relation' => [['foreign-key' => 'y', 'join-field' => 'year', 'operator' => '='],],
        ],
        [
            'name' => 'monthly_summary_total',
            'view' => 'years',
            'table' => 'dummy',
            'key' => 'year',
            'records' => 100,
            'maxrecords' => 100,
            'calculation' => [
                ['field' => "income_item_all", 'expression' => "sum(monthly_summary@income_item_total)",],
                ['field' => "income_net_all", 'expression' => "sum(monthly_summary@income_net_total)",],
                ['field' => "income_tax_all", 'expression' => "sum(monthly_summary@income_tax_total)",],
                ['field' => "purchase_item_all", 'expression' => "sum(monthly_summary@purchase_item_total)",],
                ['field' => "purchase_net_all", 'expression' => "sum(monthly_summary@purchase_net_total)",],
                ['field' => "purchase_tax_all", 'expression' => "sum(monthly_summary@purchase_tax_total)",],
                ['field' => "others_item_all", 'expression' => "sum(monthly_summary@others_item_total)",],
                ['field' => "others_net_all", 'expression' => "sum(monthly_summary@others_net_total)",],
                ['field' => "others_tax_all", 'expression' => "sum(monthly_summary@others_tax_total)",],
            ],
        ],
        [
            'name' => 'monthly_detail',
            'view' => 'monthly_summary',
            'table' => 'dummy',
            'key' => 'ym',
            'records' => 1,
            'soft-delete' => true,
        ],
        [
            'name' => 'account_income',
            'view' => 'account_list',
            'table' => 'dummy',
            'key' => 'account_id',
            'records' => 1000000,
            'relation' => [['foreign-key' => 'ym', 'join-field' => 'ym', 'operator' => '='],],
            'query' => [
                ['field' => 'credit_id', 'operator' => '=', 'value' => '700'],
                ['field' => 'debit_id', 'operator' => '=', 'value' => '700'],
                ['field' => '__operation__', 'operator' => 'ex'],
            ],
            'sort' => [['field' => 'issued_date', 'direction' => 'ASC'],],
            'soft-delete' => true,
        ],
        [
            'name' => 'account_purchase',
            'view' => 'account_list',
            'table' => 'dummy',
            'key' => 'account_id',
            'records' => 1000000,
            'relation' => [['foreign-key' => 'ym', 'join-field' => 'ym', 'operator' => '='],],
            'query' => [
                ['field' => 'is_purchase', 'operator' => '=', 'value' => '1'],
                ['field' => 'credit_is_purchase', 'operator' => '=', 'value' => '1'],
                ['field' => '__operation__', 'operator' => 'ex'],
            ],
            'sort' => [['field' => 'issued_date', 'direction' => 'ASC'],],
            'soft-delete' => true,
        ],
        [
            'name' => 'account_others',
            'view' => 'account_list',
            'table' => 'dummy',
            'key' => 'account_id',
            'records' => 1000000,
            'relation' => [['foreign-key' => 'ym', 'join-field' => 'ym', 'operator' => '='],],
            'query' => [
                ['field' => 'is_other_exp', 'operator' => '=', 'value' => '1'],
                ['field' => 'credit_is_other_exp', 'operator' => '=', 'value' => '1'],
                ['field' => '__operation__', 'operator' => 'ex'],
            ],
            'sort' => [['field' => 'issued_date', 'direction' => 'ASC'],],
            'soft-delete' => true,
        ],
        [
            'name' => 'year_list',
            'view' => 'fiscal_year',
            'table' => 'dummy',
            'key' => 'year',
            'records' => 100,
            'maxrecords' => 100000,
            'navi-control' => 'master-hide',
        ],
        [
            'name' => 'year_detail',
            'view' => 'fiscal_year',
            'table' => 'dummy',
            'key' => 'year',
            'records' => 1,
            'navi-control' => 'detail',
        ],
        [
            'name' => 'year_detail_single',
            'view' => 'fiscal_year',
            'table' => 'dummy',
            'key' => 'year',
            'records' => 1,
        ],
        [
            'name' => 'item_debit',
            'view' => 'item_summary_debit',
            'table' => 'dummy',
            'records' => 10000,
            'relation' => [['foreign-key' => 'y', 'join-field' => 'year', 'operator' => '='],],
            'sort' => [['field' => 'debit_id', 'direction' => 'ASC'],],
        ],
        [
            'name' => 'account_debit',
            'view' => 'account_list',
            'table' => 'dummy',
            'key' => 'account_id',
            'records' => 1000000,
            'soft-delete' => true,
            'relation' => [
                ['foreign-key' => 'debit_id', 'join-field' => 'debit_id', 'operator' => '='],
                ['foreign-key' => 'y', 'join-field' => 'y', 'operator' => '='],
            ],
            'sort' => [['field' => 'issued_date', 'direction' => 'ASC'],],
        ],
        [
            'name' => 'item_credit',
            'view' => 'item_summary_credit',
            'table' => 'dummy',
            'records' => 10000,
            'relation' => [['foreign-key' => 'y', 'join-field' => 'year', 'operator' => '='],],
            'sort' => [['field' => 'credit_id', 'direction' => 'ASC'],],
        ],
        [
            'name' => 'account_credit',
            'view' => 'account_list',
            'table' => 'dummy',
            'key' => 'account_id',
            'records' => 1000000,
            'soft-delete' => true,
            'relation' => [
                ['foreign-key' => 'credit_id', 'join-field' => 'credit_id', 'operator' => '='],
                ['foreign-key' => 'y', 'join-field' => 'y', 'operator' => '='],
            ],
            'sort' => [['field' => 'issued_date', 'direction' => 'ASC'],],
        ],
    ],
    [],
    ['db-class' => 'PDO',],
    2
);
