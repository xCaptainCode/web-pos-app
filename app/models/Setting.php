<?php

class Setting extends \Phalcon\Mvc\Model
{
    public $key;
    public $value;
    public $description;
    public $updated_at;

    public function initialize()
    {
        $this->setSource('settings');
    }

    public function getSource()
    {
        return 'settings';
    }

    /**
     * Helper to get setting value by key
     */
    public static function getVal($key, $default = null)
    {
        $setting = self::findFirstByKey($key);
        return $setting ? $setting->value : $default;
    }
}
