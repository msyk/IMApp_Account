<?php

require_once '../vendor/inter-mediator/inter-mediator/INTER-Mediator.php';

use \INTERMediator\DB\Proxy_ExtSupport;
use \INTERMediator\DB\UseSharedObjects;

class GetPreference extends UseSharedObjects
{
    use Proxy_ExtSupport;

    function processing()
    {
        $target = 'preference';
        $result = $this->dbRead($target);
        return $result;
    }
}

$result = (new GetPreference())->processing();
$str = $result[0]['copy_detail'] ? 'true' : 'false';

echo "let copyDetail = {$str}\n\n";

