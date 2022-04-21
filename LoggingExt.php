<?php

class LoggingExt extends INTERMediator\DB\Support\OperationLogExtension
{
    public function extendingFields()
    {
        return ['key_value', 'edit_field', 'edit_value'];
    }

    public function valueForField($field)
    {
        $rValue = null;
        $access = $_POST['access'];
        switch ($field) {
            case 'key_value':
                if ($access == 'create' || $access == 'copy') {
                    $rValue = $this->result['newRecordKeyValue'] ?? NULL;
                } else {
                    $rValue = $_POST['condition0value'] ?? NULL;
                }
                break;
            case 'edit_field':
                $cnt = 0;
                $rValue = '';
                if ($access == 'copy') {
                    while (isset($_POST["condition{$cnt}field"])) {
                        $rValue .= ($cnt > 0 ? '<br>' : '') . "from:" . $_POST["condition{$cnt}field"];
                        $cnt += 1;
                    }
                } else {
                    while (isset($_POST["field_{$cnt}"])) {
                        $rValue .= ($cnt > 0 ? '<br>' : '') . $_POST["field_{$cnt}"];
                        $cnt += 1;
                    }
                }
                break;
            case 'edit_value':
                $cnt = 0;
                $rValue = '';
                if ($access == 'copy') {
                    while (isset($_POST["condition{$cnt}value"])) {
                        $rValue .= ($cnt > 0 ? '<br>' : '') . $_POST["condition{$cnt}value"];
                        $cnt += 1;
                    }
                } else {
                    while (isset($_POST["value_{$cnt}"])) {
                        $rValue .= ($cnt > 0 ? '<br>' : '') . $_POST["value_{$cnt}"];
                        $cnt += 1;
                    }
                }
                break;
        }
        return $rValue;
    }
}