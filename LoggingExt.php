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
        if ($access == 'create') {
            switch ($field) {
                case 'key_value':
                    $rValue = $this->result['newRecordKeyValue'] ?? NULL;
                    break;
                case 'edit_field':
                    $cnt = 0;
                    $rValue = '';
                    while (isset($_POST["field_{$cnt}"])) {
                        $rValue .= ($cnt > 0 ? '<br>' : '') . $_POST["field_{$cnt}"];
                        $cnt += 1;
                    }
                    break;
                case 'edit_value':
                    $cnt = 0;
                    $rValue = '';
                    while (isset($_POST["value_{$cnt}"])) {
                        $rValue .= ($cnt > 0 ? '<br>' : '') . $_POST["value_{$cnt}"];
                        $cnt += 1;
                    }
                    break;
            }
        } else {
            switch ($field) {
                case 'key_value':
                    $rValue = $_POST['condition0value'] ?? NULL;
                    break;
                case 'edit_field':
                    $rValue = $_POST['field_0'] ?? NULL;
                    break;
                case 'edit_value':
                    $rValue = $_POST['value_0'] ?? NULL;
                    break;
            }
        }
        return $rValue;
    }
}