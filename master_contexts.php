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
            'name' => 'assort_pattern',
            'key' => 'assort_pattern_id',
            'records' => 10000,
            'sort' => [['field' => 'assort_pattern_id', 'direction' => 'asc'],],
            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
        ],
        [
            'name' => 'item',
            'key' => 'item_id',
            'records' => 10000,
            'sort' => [['field' => 'item_id', 'direction' => 'asc'],],
            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
        ],
        [
            'name' => 'company',
            'key' => 'company_id',
            'records' => 10000,
            'sort' => [['field' => 'company_id', 'direction' => 'asc'],],
            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
        ],
        [
            'name' => 'fiscal_year',
            'key' => 'year',
            'records' => 10000,
            'sort' => [['field' => 'year', 'direction' => 'asc'],],
            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
        ],
        [
            'name' => 'item_select',
            'view' => 'item',
            'key' => 'item_id',
            'records' => 10000,
            'query' => [['field' => 'show', 'value' => 1],],
            'sort' => [['field' => 'item_id', 'direction' => 'asc'],],
        ],
        [
            'name' => 'preference',
            'key' => 'preference_id',
            'records' => 1,
        ],
    ],
    [],
    ['db-class' => 'PDO',],
    2
);
