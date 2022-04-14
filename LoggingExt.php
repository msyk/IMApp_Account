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
        switch ($field) {
            case 'key_value':
                $rValue = $_POST[$_POST['access'] == 'create' ? 'value_0' : 'condition0value'] ?? NULL;
                break;
            case 'edit_field':
                $rValue = $_POST['field_0'] ?? NULL;
                break;
            case 'edit_value':
                $rValue = $_POST['value_0'] ?? NULL;
                break;
        }
        return $rValue;
    }
}