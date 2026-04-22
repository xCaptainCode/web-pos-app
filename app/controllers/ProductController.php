<?php

use Product;
use Phalcon\Db;
use Phalcon\Mvc\Controller;
use Phalcon\Mvc\View;

class ProductController extends Controller
{
   const STOCK_ALERT_THRESHOLD = 5; 
   
   public function indexAction()
   {
      $category_id = $this->request->getQuery("category_id", "string");

      $sql = "SELECT 
            p.id, 
            p.name, 
            p.description, 
            p.stock, 
            p.price, 
            p.is_active, 
            c.name AS category_name, 
            p.category_id
         FROM products p
         LEFT JOIN categories c ON p.category_id = c.id";

      $params = [];
      if ($category_id && $category_id !== "All") {
         $sql .= " WHERE p.category_id = :category_id";
         $params['category_id'] = $category_id;
      }

      $sql .= " ORDER BY p.name ASC";

      $products = $this->db->fetchAll($sql, Db::FETCH_ASSOC, $params);

      $categories = $this->db->fetchAll(
         "SELECT id, name FROM categories WHERE is_active = true ORDER BY sort_order, name",
         Db::FETCH_ASSOC
      );

      $lowStockProducts = $this->db->fetchOne(
         "SELECT count(*) as total
            FROM products p
            WHERE COALESCE(p.is_active, true) = true
               AND COALESCE(p.stock, 0) <= :threshold",
         Db::FETCH_ASSOC,
         ['threshold' => self::STOCK_ALERT_THRESHOLD]
      );

      $this->view->products = json_decode(json_encode($products), false);
      $this->view->categories = json_decode(json_encode($categories), false);
      $this->view->selected_category = $category_id;
      $this->view->lowStockProducts = $lowStockProducts['total'];
   }
   public function loadAction()
   {

      $category_id = $this->request->getPost("category_id");

      if ($category_id === "All" || empty($category_id)) {
         $products = $this->db->fetchAll(
            "SELECT p.id, p.name, p.description, p.stock, p.price, p.is_active, c.name AS category_name, p.category_id
               FROM products p
               LEFT JOIN categories c ON p.category_id = c.id
               ORDER BY p.name ASC",
            Db::FETCH_ASSOC
         );
      } else {
         $products = $this->db->fetchAll(
            "SELECT p.id, p.name, p.description, p.stock, p.price, p.is_active, c.name AS category_name, p.category_id
               FROM products p
               LEFT JOIN categories c ON p.category_id = c.id
               WHERE p.category_id = :category_id
               ORDER BY p.name ASC",
            Db::FETCH_ASSOC,
            ["category_id" => $category_id]
         );
      }

      $categories = $this->db->fetchAll(
         "SELECT id, name FROM categories WHERE is_active = true ORDER BY sort_order, name",
         Db::FETCH_ASSOC
      );

      $this->view->products = json_decode(json_encode($products), false);
      $this->view->categories = json_decode(json_encode($categories), false);

      $this->view->pick('product/load');
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);
   }

   public function saveAction()
   {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->response->redirect('product');
      }

      $product = new \Product();
      $product->category_id = $this->request->getPost('category_id', 'string');
      $product->name = $this->request->getPost('name', 'string');
      $product->description = $this->request->getPost('description', 'string');
      $product->stock = $this->request->getPost('stock', 'int');
      $product->price = $this->request->getPost('price', 'int');
      $product->is_active = $this->request->getPost('is_active') === '1';

      $ref_category_id = $this->request->getPost('ref_category_id', 'string');
      $redirect_url = 'product' . ($ref_category_id ? '?category_id=' . $ref_category_id : '');

      if (!$product->save()) {
         $messages = [];
         foreach ($product->getMessages() as $message) {
            $messages[] = $message->getMessage();
         }
         $this->flashSession->error(implode('<br>', $messages));
         return $this->response->redirect($redirect_url);
      }

      $this->flashSession->notice('Produk berhasil ditambahkan.');
      return $this->response->redirect($redirect_url);
   }

   public function updateAction()
   {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->response->redirect('product');
      }

      $id = $this->request->getPost('id', 'string');
      $product = Product::findFirst([
         "id = :id:",
         "bind" => ["id" => $id]
      ]);

      if (!$product) {
         $this->flashSession->error('Produk tidak ditemukan.');
         return $this->response->redirect('product');
      }

      $product->category_id = $this->request->getPost('category_id', 'string');
      $product->name = $this->request->getPost('name', 'string');
      $product->description = $this->request->getPost('description', 'string');
      $product->stock = $this->request->getPost('stock', 'int');
      $product->price = $this->request->getPost('price', 'int');
      $product->is_active = $this->request->getPost('is_active') === '1';

      $ref_category_id = $this->request->getPost('ref_category_id', 'string');
      $redirect_url = 'product' . ($ref_category_id ? '?category_id=' . $ref_category_id : '');

      if (!$product->save()) {
         $messages = [];
         foreach ($product->getMessages() as $message) {
            $messages[] = $message->getMessage();
         }
         $this->flashSession->error(implode('<br>', $messages));
         return $this->response->redirect($redirect_url);
      }

      $this->flashSession->notice('Produk berhasil diperbarui.');
      return $this->response->redirect($redirect_url);
   }
}
