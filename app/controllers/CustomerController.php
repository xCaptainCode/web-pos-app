<?php

use Customer;
use Phalcon\Mvc\Controller;
use Phalcon\Db;

class CustomerController extends Controller
{
   public function indexAction()
   {
      $this->view->setVar("title", "Customers");

      $customers = Customer::find([
         "order" => "name ASC"
      ]);

      $this->view->customers = $customers;
   }

   public function storeAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $customer = new Customer();
         $customer->name = $this->request->getPost('name');
         $customer->phone = $this->request->getPost('phone');

         if ($customer->save()) {
            $this->flashSession->notice("Customer berhasil ditambahkan");
         } else {
            foreach ($customer->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('customer');
   }

   public function updateAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $id = $this->request->getPost('id');
         $customer = Customer::findFirstById($id);
         if ($customer) {
            $customer->name = $this->request->getPost('name');
            $customer->phone = $this->request->getPost('phone');
            $customer->loyality_points = $this->request->getPost('loyality_points') ?: null;
            $customer->total_spent = $this->request->getPost('total_spent') ?: null;

            if ($customer->save()) {
               $this->flashSession->notice("Customer berhasil diupdate");
            } else {
               foreach ($customer->getMessages() as $message) {
                  $this->flashSession->error($message->getMessage());
               }
            }
         }
      }
      return $this->response->redirect('customer');
   }

   public function deleteAction()
   {
      $this->view->disable();
      
      if ($this->request->isPost()) {
         $id = $this->request->getPost('id');
         $customer = Customer::findFirstById($id);
         if ($customer) {
            if ($customer->delete()) {
               $this->flashSession->success("Customer berhasil dihapus");
            } else {
               foreach ($customer->getMessages() as $message) {
                  $this->flashSession->error($message->getMessage());
               }
            }
         }
         return $this->response->redirect('customer');
      }
   }
   
   public function historyAction($id)
   {
      $customer = Customer::findFirstById($id);
      if (!$customer) {
         $this->flashSession->error("Customer tidak ditemukan");
         return $this->response->redirect('customer');
      }

      $this->view->setVar("title", "Riwayat Transaksi");
      $this->view->customer = $customer;

      $transactions = $this->db->fetchAll(
         "SELECT 
            o.id, 
            o.order_no, 
            u.name as cashier_name, 
            o.subtotal, 
            o.discount, 
            o.tax,
            o.total, 
            o.status,
            o.created_at
         FROM orders o
         LEFT JOIN users u ON u.id = o.user_id
         WHERE o.customer_id = :customer_id
         ORDER BY o.created_at DESC",
         Db::FETCH_ASSOC,
         ['customer_id' => $id]
      );

      $this->view->transactions = json_decode(json_encode($transactions), false);
   }
}