<?php

use \INTERMediator\DB\UseSharedObjects;
use \INTERMediator\DB\Extending\AfterCreate;
use INTERMediator\DB\Proxy_ExtSupport;

class CreateFirstItem extends UseSharedObjects implements AfterCreate
{
    use Proxy_ExtSupport;

    public function doAfterCreateToDB($result)
    {
        $this->dbCreate('detail',
            [
                'account_id' => $result[0]['account_id'],
                "unit_price" => 0,
                "qty" => 0,
            ]/*, [[
                'name' => 'detail',
                'key' => 'detail_id',
                'default-values' => [
                    ['field' => "unit_price", 'value' => "0"],
                    ['field' => "qty", 'value' => "0"],
                ],
            ],]*/);
        return $result;
    }
}