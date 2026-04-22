<?php

use Phalcon\Db;
use Phalcon\Mvc\Controller;

class IndexController extends Controller {
   const STOCK_ALERT_THRESHOLD = 5;

   public function indexAction() {
      if (! $this->hasDashboardAccess()) {
         $this->flashSession->error('Anda tidak memiliki akses ke dashboard.');
         return $this->response->redirect('cashier');
      }

      $period = $this->resolvePeriod($this->request->getQuery('period', 'string', 'today'));
      $range  = $this->getPeriodRange($period);

      $summary = $this->db->fetchOne(
         "SELECT
               COALESCE(SUM(total), 0) AS total_revenue,
               COUNT(*) AS total_orders
            FROM orders
            WHERE status = 'paid'
               AND created_at >= :start_at
               AND created_at < :end_at",
         Db::FETCH_ASSOC,
         [
            'start_at' => $range['start'],
            'end_at'   => $range['end'],
         ]
      );

      $totalRevenue = (float) $summary['total_revenue'];
      $totalOrders  = (int) $summary['total_orders'];
      $avgOrder     = $totalOrders > 0 ? $totalRevenue / $totalOrders : 0;

      $hasCustomerCreatedAt = $this->tableHasColumn('customers', 'created_at');
      $totalCustomers       = 0;

      if ($hasCustomerCreatedAt) {
         $customerSummary = $this->db->fetchOne(
            "SELECT COUNT(*) AS total_customers
               FROM customers
               WHERE created_at >= :start_at
                  AND created_at < :end_at",
            Db::FETCH_ASSOC,
            [
               'start_at' => $range['start'],
               'end_at'   => $range['end'],
            ]
         );

         $totalCustomers = (int) $customerSummary['total_customers'];
      } else {
         $customerSummary = $this->db->fetchOne(
            "SELECT COUNT(*) AS total_customers
               FROM customers",
            Db::FETCH_ASSOC
         );

         $totalCustomers = (int) $customerSummary['total_customers'];
      }

      $topProducts = $this->db->fetchAll(
         "SELECT
               p.id,
               p.name,
               COALESCE(c.name, '-') AS category_name,
               COALESCE(SUM(oi.quantity), 0)::int AS total_qty,
               COALESCE(SUM(oi.subtotal), 0) AS total_revenue
            FROM order_items oi
            INNER JOIN orders o ON o.id = oi.order_id
            INNER JOIN products p ON p.id = oi.product_id
            LEFT JOIN categories c ON c.id = p.category_id
            WHERE o.status = 'paid'
               AND o.created_at >= :start_at
               AND o.created_at < :end_at
            GROUP BY p.id, p.name, c.name
            ORDER BY total_qty DESC, total_revenue DESC
            LIMIT 5",
         Db::FETCH_ASSOC,
         [
            'start_at' => $range['start'],
            'end_at'   => $range['end'],
         ]
      );

      $latestTransactions = $this->db->fetchAll(
         "SELECT
               o.id,
               o.order_no,
               COALESCE(u.name, '-') AS cashier_name,
               COALESCE(c.name, 'Walk-in Customer') AS customer_name,
               o.total,
               o.status,
               o.created_at
            FROM orders o
            LEFT JOIN users u ON u.id = o.user_id
            LEFT JOIN customers c ON c.id = o.customer_id
            ORDER BY o.created_at DESC
            LIMIT 5",
         Db::FETCH_ASSOC
      );

      $lowStockProducts = $this->db->fetchAll(
         "SELECT
               p.id,
               p.name,
               COALESCE(c.name, '-') AS category_name,
               COALESCE(p.stock, 0) AS stock
            FROM products p
            LEFT JOIN categories c ON c.id = p.category_id
            WHERE COALESCE(p.is_active, true) = true
               AND COALESCE(p.stock, 0) <= :threshold
            ORDER BY p.stock ASC, p.name ASC
            LIMIT 5",
         Db::FETCH_ASSOC,
         ['threshold' => self::STOCK_ALERT_THRESHOLD]
      );

      $this->view->setVars([
         'period'                 => $period,
         'periodLabel'            => $range['label'],
         'chartEndpoint'          => $this->url->get('index/revenueChart?period=' . $period),
         'totalRevenue'           => $totalRevenue,
         'totalOrders'            => $totalOrders,
         'totalCustomers'         => $totalCustomers,
         'avgOrder'               => $avgOrder,
         'topProducts'            => json_decode(json_encode($topProducts), false),
         'latestTransactions'     => json_decode(json_encode($latestTransactions), false),
         'lowStockProducts'       => json_decode(json_encode($lowStockProducts), false),
         'lowStockThreshold'      => self::STOCK_ALERT_THRESHOLD,
         'hasCustomerCreatedAt'   => $hasCustomerCreatedAt,
      ]);
   }

   public function revenueChartAction() {
      $this->view->disable();

      if (! $this->hasDashboardAccess()) {
         $this->response->setStatusCode(403, 'Forbidden');
         return $this->response->setJsonContent([
            'error'   => true,
            'message' => 'Akses ditolak.',
         ]);
      }

      $period = $this->resolvePeriod($this->request->getQuery('period', 'string', 'today'));
      $range  = $this->getPeriodRange($period);

      $rows = $this->db->fetchAll(
         "SELECT
               DATE(created_at) AS order_date,
               COALESCE(SUM(total), 0) AS total_revenue
            FROM orders
            WHERE status = 'paid'
               AND created_at >= :start_at
               AND created_at < :end_at
            GROUP BY DATE(created_at)
            ORDER BY DATE(created_at) ASC",
         Db::FETCH_ASSOC,
         [
            'start_at' => $range['start'],
            'end_at'   => $range['end'],
         ]
      );

      $revenueMap = [];
      foreach ($rows as $row) {
         $revenueMap[$row['order_date']] = (float) $row['total_revenue'];
      }

      $labels = [];
      $data   = [];

      $cursor = clone $range['startDate'];
      while ($cursor < $range['endDate']) {
         $dateKey  = $cursor->format('Y-m-d');
         $labels[] = $cursor->format('d M');
         $data[]   = isset($revenueMap[$dateKey]) ? $revenueMap[$dateKey] : 0;
         $cursor   = $cursor->modify('+1 day');
      }

      $this->response->setContentType('application/json', 'UTF-8');
      return $this->response->setJsonContent([
         'error'       => false,
         'period'      => $period,
         'periodLabel' => $range['label'],
         'labels'      => $labels,
         'data'        => $data,
      ]);
   }

   private function hasDashboardAccess() {
      $role = strtoupper((string) $this->session->get('role'));
      return in_array($role, ['ADMIN', 'KASIR', 'CASHIER', 'USER'], true);
   }

   private function resolvePeriod($period) {
      $normalized = strtolower(trim((string) $period));
      if (! in_array($normalized, ['today', 'week', 'month'], true)) {
         return 'today';
      }

      return $normalized;
   }

   private function getPeriodRange($period) {
      $today = new \DateTimeImmutable('today');

      if ($period === 'week') {
         $start = $today->modify('monday this week');
         $end   = $start->modify('+7 days');
         $label = 'Minggu Ini';
      } elseif ($period === 'month') {
         $start = $today->modify('first day of this month');
         $end   = $start->modify('+1 month');
         $label = 'Bulan Ini';
      } else {
         $start = $today;
         $end   = $today->modify('+1 day');
         $label = 'Hari Ini';
      }

      return [
         'start'     => $start->format('Y-m-d H:i:s'),
         'end'       => $end->format('Y-m-d H:i:s'),
         'startDate' => $start,
         'endDate'   => $end,
         'label'     => $label,
      ];
   }

   private function tableHasColumn($tableName, $columnName) {
      $row = $this->db->fetchOne(
         "SELECT 1
            FROM information_schema.columns
            WHERE table_schema = 'public'
               AND table_name = :table_name
               AND column_name = :column_name
            LIMIT 1",
         Db::FETCH_ASSOC,
         [
            'table_name'  => $tableName,
            'column_name' => $columnName,
         ]
      );

      return (bool) $row;
   }
}
