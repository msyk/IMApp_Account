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
            'name' => 'account_detail',
            'view' => 'account_list',
            'table' => 'account',
            'key' => 'account_id',
            'records' => 1,
            'soft-delete' => true,
            'calculation' => [
                ['field' => "section_style", 'expression' => "if(section,'inline','none')",],
                ['field' => "detail_style", 'expression' => "if(preference@show_tax_detail=1,'table-cell','none')",],
                ['field' => "not_detail_style", 'expression' => "if(preference@show_tax_detail=1,'none','inline')",],
                ['field' => "label_style", 'expression' => "if(preference@show_label=1,'table-cell','none')",],
                ['field' => "post_company", 'expression' => "if(company!='' && section='',' 御中','')",],
                ['field' => "post_section", 'expression' => "if(company!='' && section!='',' 御中','')",],
                ['field' => "post_person", 'expression' => "if(person!='',' 様','')",],
                ['field' => "item_total_calc", 'expression' => "round(sum(detail_list@item_price_calc),0)",],
                ['field' => "tax_total_calc", 'expression' => "round(sum(detail_list@tax_price_calc),0)",],
                ['field' => "net_total_calc", 'expression' => "round(sum(detail_list@net_price_calc),0)",],
                ['field' => "item_total8_calc", 'expression' => "round(sum(detail_list@item_price8_calc),0)",],
                ['field' => "tax_total8_calc", 'expression' => "round(sum(detail_list@tax_price8_calc),0)",],
                ['field' => "net_total8_calc", 'expression' => "round(sum(detail_list@net_price8_calc),0)",],
                ['field' => "item_total10_calc", 'expression' => "round(sum(detail_list@item_price10_calc),0)",],
                ['field' => "tax_total10_calc", 'expression' => "round(sum(detail_list@tax_price10_calc),0)",],
                ['field' => "net_total10_calc", 'expression' => "round(sum(detail_list@net_price10_calc),0)",],
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
            'soft-delete' => true,
            'relation' => [['foreign-key' => 'account_id', 'join-field' => 'account_id', 'operator' => '='],],
            'calculation' => [
                ['field' => "detail_style", 'expression' => "if(preference@show_tax_detail=1,'table-cell','none')",],
                ['field' => "item_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),1,1 + tax_rate,1),choice(abs(account_detail@tax_kind+0),1,1 + account_detail@tax_rate,1))",],
                ['field' => "net_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),1/(1 + tax_rate),1,1),choice(abs(account_detail@tax_kind+0),1/(1 + account_detail@tax_rate),1,1))",],
                ['field' => "tax_price_calc", 'expression' => "unit_price * qty * alloc_rate * if(tax_rate>0,choice(abs(account_detail@tax_kind+0),tax_rate/(1 + tax_rate),tax_rate,0),choice(abs(account_detail@tax_kind+0),account_detail@tax_rate/(1 + account_detail@tax_rate),account_detail@tax_rate,0))",],
                ['field' => "item_price8_calc", 'expression' => "if(tax_rate=0.08||(tax_rate=''&&account_detail@tax_rate=0.08),item_price_calc,0)",],
                ['field' => "net_price8_calc", 'expression' => "if(tax_rate=0.08||(tax_rate=''&&account_detail@tax_rate=0.08),net_price_calc,0)",],
                ['field' => "tax_price8_calc", 'expression' => "if(tax_rate=0.08||(tax_rate=''&&account_detail@tax_rate=0.08),tax_price_calc,0)",],
                ['field' => "item_price10_calc", 'expression' => "if(tax_rate=0.1||(tax_rate=''&&account_detail@tax_rate=0.1),item_price_calc,0)",],
                ['field' => "net_price10_calc", 'expression' => "if(tax_rate=0.1||(tax_rate=''&&account_detail@tax_rate=0.1),net_price_calc,0)",],
                ['field' => "tax_price10_calc", 'expression' => "if(tax_rate=0.1||(tax_rate=''&&account_detail@tax_rate=0.1),tax_price_calc,0)",],
            ],
        ],
        [
            'name' => 'preference',
            'key' => 'preference_id',
            'records' => 1,
        ],
    ],
    [
//        'authentication' => [
//            'authexpired' => '7200',
//            'storing' => 'credential',
//        ],
    ],
    ['db-class' => 'PDO',],
    false
);
