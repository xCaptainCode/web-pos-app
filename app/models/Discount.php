<?php

class Discount extends \Phalcon\Mvc\Model
{
    public $id;
    public $name;
    public $type;
    public $value;
    public $valid_from;
    public $valid_until;

    public function initialize()
    {
        $this->setSource('discounts');
    }

    public function getSource()
    {
        return 'discounts';
    }

    public function validation()
    {
        $validator = new \Phalcon\Validation();

        $validator->add(
            'valid_until',
            new \Phalcon\Validation\Validator\Callback(
                [
                    'callback' => function($data) {
                        return strtotime($data->valid_until) >= strtotime($data->valid_from);
                    },
                    'message'  => 'Tanggal berakhir tidak boleh lebih kecil dari tanggal mulai'
                ]
            )
        );

        return $this->validate($validator);
    }

    public function beforeValidationOnCreate()
    {
        // UUID generation if needed, but let's see if the DB handles it.
        // If not, we can use Phalcon's Security or a simple UUID generator.
        if (!$this->id) {
            $this->id = $this->generateUuid();
        }
    }

    private function generateUuid()
    {
        return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
        );
    }
}
