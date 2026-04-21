<?php

use Phalcon\Db;
use Phalcon\Mvc\Controller;

class CashierController extends Controller {
   const DEFAULT_TAX_PERCENT = 0;

   public function indexAction() {
      $products = $this->db->fetchAll(
         "SELECT
               p.id,
               p.name,
               p.description,
               p.stock,
               p.price,
               p.is_active,
               p.category_id,
               c.name AS category_name
            FROM products p
            LEFT JOIN categories c ON c.id = p.category_id
            ORDER BY p.name ASC",
         Db::FETCH_ASSOC
      );

      $categories = $this->db->fetchAll(
         "SELECT id, name
            FROM categories
            WHERE is_active = true
            ORDER BY sort_order ASC, name ASC",
         Db::FETCH_ASSOC
      );

      $customers = $this->db->fetchAll(
         "SELECT id, name, phone
            FROM customers
            ORDER BY name ASC",
         Db::FETCH_ASSOC
      );

      $discounts = $this->db->fetchAll(
         "SELECT
               id,
               name,
               type,
               value,
               valid_from,
               valid_until
            FROM discounts
            WHERE (valid_from IS NULL OR valid_from <= CURRENT_DATE)
               AND (valid_until IS NULL OR valid_until >= CURRENT_DATE)
            ORDER BY name ASC",
         Db::FETCH_ASSOC
      );

      $this->view->products          = json_decode(json_encode($products), false);
      $this->view->categories        = json_decode(json_encode($categories), false);
      $this->view->customers         = json_decode(json_encode($customers), false);
      $this->view->discounts         = json_decode(json_encode($discounts), false);
      $this->view->defaultTaxPercent = self::DEFAULT_TAX_PERCENT;
   }

   public function checkoutAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('cashier');
      }

      $cartJson = $this->request->getPost('cart_json');
      $items    = json_decode($cartJson, true);

      if (json_last_error() !== JSON_ERROR_NONE || ! is_array($items) || empty($items)) {
         $this->flashSession->error('Keranjang tidak valid atau kosong.');
         return $this->response->redirect('cashier');
      }

      $manualDiscount = max(0, (float) $this->request->getPost('manual_discount'));
      $taxPercent     = max(0, (float) $this->request->getPost('tax_percent'));
      $amountPaid     = (float) $this->request->getPost('amount_paid');

      $paymentMethod = trim((string) $this->request->getPost('payment_method'));
      if ($paymentMethod === '') {
         $paymentMethod = 'CASH';
      }

      $customerId = trim((string) $this->request->getPost('customer_id'));
      if ($customerId === '') {
         $customerId = null;
      }

      $discountId = trim((string) $this->request->getPost('discount_id'));
      if ($discountId === '') {
         $discountId = null;
      }

      $db = $this->db;
      $db->begin();

      try {
         $validatedItems = [];
         $subtotal       = 0;

         foreach ($items as $rawItem) {
            $productId = isset($rawItem['id']) ? trim((string) $rawItem['id']) : '';
            $qty       = isset($rawItem['qty']) ? (int) $rawItem['qty'] : 0;

            if ($productId === '' || $qty <= 0) {
               throw new \Exception('Item keranjang tidak valid.');
            }

            $product = $db->fetchOne(
               "SELECT id, name, stock, price, is_active
                  FROM products
                  WHERE id = :id",
               Db::FETCH_ASSOC,
               ['id' => $productId]
            );

            if (! $product) {
               throw new \Exception('Produk tidak ditemukan.');
            }

            if (! (bool) $product['is_active']) {
               throw new \Exception('Produk ' . $product['name'] . ' sedang tidak aktif.');
            }

            if ($qty > (int) $product['stock']) {
               throw new \Exception('Stok produk ' . $product['name'] . ' tidak mencukupi.');
            }

            $unitPrice    = (float) $product['price'];
            $itemSubtotal = $unitPrice * $qty;

            $subtotal += $itemSubtotal;

            $validatedItems[] = [
               'product_id' => $product['id'],
               'name'       => $product['name'],
               'quantity'   => $qty,
               'unit_price' => $unitPrice,
               'subtotal'   => $itemSubtotal,
            ];
         }

         $promoDiscount = 0;
         if ($discountId !== null) {
            $discount = $db->fetchOne(
               "SELECT id, name, type, value
                  FROM discounts
                  WHERE id = :id
                     AND (valid_from IS NULL OR valid_from <= CURRENT_DATE)
                     AND (valid_until IS NULL OR valid_until >= CURRENT_DATE)",
               Db::FETCH_ASSOC,
               ['id' => $discountId]
            );

            if (! $discount) {
               throw new \Exception('Promo diskon tidak valid atau sudah tidak aktif.');
            }

            $discountValue = (float) $discount['value'];
            if ($discount['type'] === 'percentage') {
               $promoDiscount = ($subtotal * $discountValue) / 100;
            } elseif ($discount['type'] === 'fixed_amount') {
               $promoDiscount = $discountValue;
            }
         }

         $discountTotal = min($subtotal, $manualDiscount + $promoDiscount);
         $taxBase       = max(0, $subtotal - $discountTotal);
         $taxAmount     = ($taxBase * $taxPercent) / 100;
         $total         = $taxBase + $taxAmount;

         if ($amountPaid < $total) {
            throw new \Exception('Jumlah bayar kurang dari total transaksi.');
         }

         if ($customerId !== null) {
            $customer = $db->fetchOne(
               "SELECT id FROM customers WHERE id = :id",
               Db::FETCH_ASSOC,
               ['id' => $customerId]
            );

            if (! $customer) {
               throw new \Exception('Customer tidak ditemukan.');
            }
         }

         $orderNo = $this->generateOrderNo($db);

         $userId = $this->session->get('id');
         if (! $userId) {
            throw new \Exception('Sesi login tidak valid. Silakan login ulang.');
         }

         $insertOrder = $db->fetchOne(
            "INSERT INTO orders
                  (user_id, customer_id, order_no, subtotal, discount, tax, total, status, created_at)
               VALUES
                  (:user_id, :customer_id, :order_no, :subtotal, :discount, :tax, :total, :status, NOW())
               RETURNING id",
            Db::FETCH_ASSOC,
            [
               'user_id'     => $userId,
               'customer_id' => $customerId,
               'order_no'    => $orderNo,
               'subtotal'    => $subtotal,
               'discount'    => $discountTotal,
               'tax'         => $taxAmount,
               'total'       => $total,
               'status'      => 'paid',
            ]
         );

         if (! $insertOrder || empty($insertOrder['id'])) {
            throw new \Exception('Gagal membuat order.');
         }

         $orderId = $insertOrder['id'];

         foreach ($validatedItems as $item) {
            $db->execute(
               "INSERT INTO order_items
                     (order_id, product_id, quantity, unit_price, discount, subtotal)
                  VALUES
                     (:order_id, :product_id, :quantity, :unit_price, :discount, :subtotal)",
               [
                  'order_id'   => $orderId,
                  'product_id' => $item['product_id'],
                  'quantity'   => $item['quantity'],
                  'unit_price' => $item['unit_price'],
                  'discount'   => 0,
                  'subtotal'   => $item['subtotal'],
               ]
            );

            $db->execute(
               "UPDATE products
                  SET stock = stock - :qty
                  WHERE id = :id",
               [
                  'qty' => $item['quantity'],
                  'id'  => $item['product_id'],
               ]
            );
         }

         if ($customerId !== null) {
            $db->execute(
               "UPDATE customers
                  SET total_spent = COALESCE(total_spent, 0) + :total,
                     loyality_points = COALESCE(loyality_points, 0) + :points
                  WHERE id = :id",
               [
                  'total'  => $total,
                  'points' => (int) floor($total / 10000), // 10000 = 1 point
                  'id'     => $customerId,
               ]
            );
         }

         $db->commit();

         $change  = $amountPaid - $total;
         $message = sprintf(
            // 'Transaksi %s berhasil. <br>Kembalian: Rp %s (%s)',
            'Transaksi berhasil. <br> Order No: %s<br><br> Kembalian:<br> Rp %s<br><br> Metode Pembayaran:<br> (%s)',
            $orderNo,
            number_format($change, 0, ',', '.'),
            strtoupper($paymentMethod)
         );

         $this->flashSession->success($message);
         return $this->response->redirect('cashier');
      } catch (\Exception $e) {
         $db->rollback();
         $this->flashSession->error($e->getMessage());
         return $this->response->redirect('cashier');
      }
   }

   private function generateOrderNo($db) {
      $dateCode = date('Ymd');
      $prefix   = 'TRX-' . $dateCode . '-';

      $row = $db->fetchOne(
         "SELECT COUNT(*)::int AS total
            FROM orders
            WHERE order_no LIKE :prefix",
         Db::FETCH_ASSOC,
         ['prefix' => $prefix . '%']
      );

      $next = ((int) $row['total']) + 1;

      return sprintf('%s%03d', $prefix, $next);
   }
}
