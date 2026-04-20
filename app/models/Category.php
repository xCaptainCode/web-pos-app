<?php

use Phalcon\Mvc\Model;

class Category extends Model
{
   public $id;
   public $name;
   public $description;
   /**
    * Summary of is_active
    * @var bool
    */
   public $is_active;
   public $sort_order;

   public function initialize()
   {
      $this->setSource('categories');
   }

   public function getSource()
   {
      return 'categories';
   }
}