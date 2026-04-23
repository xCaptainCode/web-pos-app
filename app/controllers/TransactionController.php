<?php

use Phalcon\Db;
use Phalcon\Mvc\Controller;

class TransactionController extends Controller {

   public function indexAction() {
      $dateFrom = $this->request->getQuery('date_from', 'string', date('Y-m-d'));
      $dateTo   = $this->request->getQuery('date_to', 'string', date('Y-m-d'));
      $status   = $this->request->getQuery('status', 'string', '');
      $userId   = $this->request->getQuery('user_id', 'string', '');

      $sql = "SELECT 
               o.id, 
               o.order_no, 
               o.subtotal, 
               o.discount, 
               o.tax, 
               o.total, 
               o.status, 
               o.created_at,
               COALESCE(u.name, '-') as cashier_name,
               COALESCE(c.name, 'Walk-in Customer') as customer_name
            FROM orders o
            LEFT JOIN users u ON o.user_id = u.id
            LEFT JOIN customers c ON o.customer_id = c.id
            WHERE o.created_at::date BETWEEN :date_from AND :date_to";
      
      $params = [
         'date_from' => $dateFrom,
         'date_to'   => $dateTo
      ];

      if ($status !== '') {
         $sql .= " AND o.status = :status";
         $params['status'] = $status;
      }

      if ($userId !== '') {
         $sql .= " AND o.user_id = :user_id";
         $params['user_id'] = $userId;
      }

      $sql .= " ORDER BY o.created_at DESC";

      $orders = $this->db->fetchAll($sql, Db::FETCH_ASSOC, $params);

      $cashiers = $this->db->fetchAll("SELECT id, name FROM users WHERE is_active = true ORDER BY name", Db::FETCH_ASSOC);

      $this->view->setVars([
         'orders'    => json_decode(json_encode($orders), false),
         'cashiers'  => json_decode(json_encode($cashiers), false),
         'filters'   => (object) [
            'date_from' => $dateFrom,
            'date_to'   => $dateTo,
            'status'    => $status,
            'user_id'   => $userId
         ]
      ]);
   }

   public function detailAction($id) {
      $this->view->disable();
      $orderId = trim((string) $id);

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
               COALESCE(c.name, 'Walk-in Customer') AS customer_name
            FROM orders o
            LEFT JOIN users u ON u.id = o.user_id
            LEFT JOIN customers c ON c.id = o.customer_id
            WHERE o.id = :id",
         Db::FETCH_ASSOC,
         ['id' => $orderId]
      );

      if (!$order) {
         return $this->response->setJsonContent(['success' => false, 'message' => 'Order tidak ditemukan']);
      }

      $items = $this->db->fetchAll(
         "SELECT
               COALESCE(p.name, '-') AS product_name,
               oi.quantity,
               oi.unit_price,
               oi.discount,
               oi.subtotal
            FROM order_items oi
            LEFT JOIN products p ON p.id = oi.product_id
            WHERE oi.order_id = :order_id",
         Db::FETCH_ASSOC,
         ['order_id' => $orderId]
      );

      return $this->response->setJsonContent([
         'success' => true,
         'order'   => $order,
         'items'   => $items
      ]);
   }

   public function voidAction($id) {
      $id = trim($id);
      $db = $this->db;
      $db->begin();
      try {
         $order = $db->fetchOne("SELECT id, status, customer_id, total FROM orders WHERE id = :id", Db::FETCH_ASSOC, ['id' => $id]);
         if (!$order) throw new \Exception("Order tidak ditemukan.");
         if (in_array($order['status'], ['cancelled', 'refunded'])) {
            throw new \Exception("Order sudah " . strtoupper($order['status']) . ".");
         }

         // Update status
         $db->execute("UPDATE orders SET status = 'cancelled' WHERE id = :id", ['id' => $id]);

         // Restore stock
         $items = $db->fetchAll("SELECT product_id, quantity FROM order_items WHERE order_id = :id", Db::FETCH_ASSOC, ['id' => $id]);
         foreach ($items as $item) {
            $db->execute("UPDATE products SET stock = stock + :qty WHERE id = :pid", [
               'qty' => $item['quantity'],
               'pid' => $item['product_id']
            ]);
         }

         // update loyalty points dan total spent customer jika ada customer
         $points = floor($order['total'] / 10000);
         $db->execute("UPDATE customers SET loyality_points = loyality_points - :points, total_spent = total_spent - :total_spent WHERE id = :id", [
            'points' => $points,
            'total_spent' => $order['total'],
            'id' => $order['customer_id']
         ]);

         $db->commit();
         $this->flashSession->success("Transaksi berhasil dibatalkan (VOID). Stok telah dikembalikan.");
      } catch (\Exception $e) {
         $db->rollback();
         $this->flashSession->error("Gagal VOID: " . $e->getMessage());
      }
      return $this->response->redirect('transaction');
   }
   public function refundAction($id) {
      $id = trim($id);
      $db = $this->db;
      $db->begin();
      try {
         $order = $db->fetchOne("SELECT id, status, customer_id, total FROM orders WHERE id = :id", Db::FETCH_ASSOC, ['id' => $id]);
         if (!$order) throw new \Exception("Order tidak ditemukan.");
         if (in_array($order['status'], ['cancelled', 'refunded'])) {
            throw new \Exception("Order sudah " . strtoupper($order['status']) . ".");
         }

         // Update status
         $db->execute("UPDATE orders SET status = 'refunded' WHERE id = :id", ['id' => $id]);

         // Restore stock
         $items = $db->fetchAll("SELECT product_id, quantity FROM order_items WHERE order_id = :id", Db::FETCH_ASSOC, ['id' => $id]);
         foreach ($items as $item) {
            $db->execute("UPDATE products SET stock = stock + :qty WHERE id = :pid", [
               'qty' => $item['quantity'],
               'pid' => $item['product_id']
            ]);
         }

         // point = kelipatan 10000, etc: 25000 -> 2, 35000 -> 3
         $points = floor($order['total'] / 10000);

         // update loyalty points dan total spent customer jika ada customer
         $db->execute("UPDATE customers SET loyality_points = loyality_points - :points, total_spent = total_spent - :total_spent WHERE id = :id", [
            'points' => $points,
            'total_spent' => $order['total'],
            'id' => $order['customer_id']
         ]);

         $db->commit();
         $this->flashSession->success("Transaksi berhasil di-refund. Stok telah dikembalikan.");
      } catch (\Exception $e) {
         $db->rollback();
         // $this->flashSession->error("Gagal REFUND: " . $e->getMessage());
         echo $e->getMessage();
         die();
      }
      return $this->response->redirect('transaction');
   }

   public function printAction($id) {
      $orderId = trim((string) $id);
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
               COALESCE(c.name, 'Walk-in Customer') AS customer_name
            FROM orders o
            LEFT JOIN users u ON u.id = o.user_id
            LEFT JOIN customers c ON c.id = o.customer_id
            WHERE o.id = :id",
         Db::FETCH_ASSOC,
         ['id' => $orderId]
      );

      if (!$order) {
         $this->flashSession->error('Order tidak ditemukan.');
         return $this->response->redirect('transaction');
      }

      $items = $this->db->fetchAll(
         "SELECT
               COALESCE(p.name, '-') AS product_name,
               oi.quantity,
               oi.unit_price,
               oi.discount,
               oi.subtotal
            FROM order_items oi
            LEFT JOIN products p ON p.id = oi.product_id
            WHERE oi.order_id = :order_id",
         Db::FETCH_ASSOC,
         ['order_id' => $orderId]
      );

      $this->view->setVars([
         'order' => (object) $order,
         'items' => json_decode(json_encode($items), false)
      ]);
      $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
   }
}
