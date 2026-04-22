<?php

use Phalcon\Mvc\Model;

class Customer extends Model
{
   public $id;
   public $name;
   public $phone;
   public $loyality_points;
   public $total_spent;

   public function initialize()
   {
      $this->setSource('customers');
   }

   public function getSource()
   {
      return 'customers';
   }
}