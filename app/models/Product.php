<?php

class Product extends \Phalcon\Mvc\Model
{
    public $id;
    public $category_id;
    public $name;
    public $description;
    public $stock;
    public $price;
    public $is_active;

    public function initialize()
    {
        $this->setSource('products');
    }

    public function getSource()
    {
        return 'products';
    }
}
