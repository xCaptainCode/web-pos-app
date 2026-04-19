<?php

use Phalcon\Db;
use Phalcon\Mvc\Controller;

class ProductController extends Controller {
   public function indexAction() {
      $products = $this->db->fetchAll(
         "SELECT p.id, p.name, p.description, p.stock, p.price, p.is_active, c.name AS category_name, p.category_id
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            ORDER BY p.name ASC",
         Db::FETCH_ASSOC
      );

      $categories = $this->db->fetchAll(
         "SELECT id, name FROM categories WHERE is_active = true ORDER BY sort_order, name",
         Db::FETCH_ASSOC
      );

      $this->view->products   = json_decode(json_encode($products), false);
      $this->view->categories = json_decode(json_encode($categories), false); 
   }

   public function saveAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('product');
      }

      $product              = new \Product();
      $product->category_id = $this->request->getPost('category_id', 'string');
      $product->name        = $this->request->getPost('name', 'string');
      $product->description = $this->request->getPost('description', 'string');
      $product->stock       = $this->request->getPost('stock', 'int');
      $product->price       = $this->request->getPost('price', 'int');
      $product->is_active   = $this->request->getPost('is_active') === '1';

      if (! $product->save()) {
         $messages = [];
         foreach ($product->getMessages() as $message) {
            $messages[] = $message->getMessage();
         }
         $this->flashSession->error(implode('<br>', $messages));
         return $this->response->redirect('product');
      }

      $this->flashSession->notice('Produk berhasil ditambahkan.');
      return $this->response->redirect('product');
   }

   public function updateAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('product');
      }

      
      $id          = $this->request->getPost('id', 'string');
      $category_id = $this->request->getPost('category_id', 'string');
      $name        = $this->request->getPost('name', 'string');
      $description = $this->request->getPost('description', 'string');
      $stock       = $this->request->getPost('stock', 'int');
      $price       = $this->request->getPost('price', 'int');
      $is_active   = $this->request->getPost('is_active');

      try {
         $update = "UPDATE products SET category_id = :category_id, name = :name, description = :description, stock = :stock, price = :price, is_active = :is_active WHERE id = :id";
         $this->db->execute($update, [
            'category_id' => $category_id,
            'name'        => $name,
            'description' => $description,
            'stock'       => $stock,
            'price'       => $price,
            'is_active'   => $is_active,
            'id'          => $id
         ]);

         $this->flashSession->notice('Produk berhasil diperbarui.');
      } catch (Exception $e) {
         $this->flashSession->error($e->getMessage());
         return $this->response->redirect('product');
      }

      return $this->response->redirect('product');
   }
}
