<?php

use Phalcon\Db;
use Phalcon\Mvc\Controller;

class OrderController extends Controller {
   public function detailAction($id) {
      $orderId = trim((string) $id);
      if ($orderId === '') {
         $this->flashSession->error('Order tidak ditemukan.');
         return $this->response->redirect('index');
      }

      $order = $this->db->fetchOne(
         "SELECT
               o.id,
               o.order_no,
               o.subtotal,
               o.discount,
               o.tax,
               o.total,
               o.status,
               o.created_at,
               COALESCE(u.name, '-') AS cashier_name,
               COALESCE(c.name, 'Walk-in Customer') AS customer_name,
               c.phone AS customer_phone
            FROM orders o
            LEFT JOIN users u ON u.id = o.user_id
            LEFT JOIN customers c ON c.id = o.customer_id
            WHERE o.id = :id
            LIMIT 1",
         Db::FETCH_ASSOC,
         ['id' => $orderId]
      );

      if (! $order) {
         $this->flashSession->error('Order tidak ditemukan.');
         return $this->response->redirect('index');
      }

      $items = $this->db->fetchAll(
         "SELECT
               oi.product_id,
               COALESCE(p.name, '-') AS product_name,
               oi.quantity,
               oi.unit_price,
               oi.discount,
               oi.subtotal
            FROM order_items oi
            LEFT JOIN products p ON p.id = oi.product_id
            WHERE oi.order_id = :order_id
            ORDER BY product_name ASC",
         Db::FETCH_ASSOC,
         ['order_id' => $orderId]
      );

      $this->view->setVars([
         'order' => (object) $order,
         'items' => json_decode(json_encode($items), false),
      ]);
   }
}
