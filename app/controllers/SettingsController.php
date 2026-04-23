<?php

use Phalcon\Mvc\Controller;
use Phalcon\Db;

class SettingsController extends Controller
{
   /**
    * Users Setting
    */
   public function userAction()
   {
      $this->view->setVar("title", "User Management");

      $users = User::find([
         "order" => "name ASC"
      ]);

      $this->view->users = $users;
   }

   public function userStoreAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $user = new User();
         $user->name      = $this->request->getPost('name');
         $user->username  = $this->request->getPost('username');
         $user->role      = $this->request->getPost('role');
         $user->password  = md5($this->request->getPost('password'));
         $user->is_active = "Y";

         if ($user->save()) {
            $this->flashSession->notice("User berhasil ditambahkan");
         } else {
            foreach ($user->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('settings/user');
   }

   public function userUpdateAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $id = $this->request->getPost('id');
         $user = User::findFirstById($id);
         if ($user) {
            $user->name      = $this->request->getPost('name');
            $user->username  = $this->request->getPost('username');
            $user->role      = $this->request->getPost('role');
            $user->is_active = $this->request->getPost('is_active') ? 'Y' : 'N';

            $password = $this->request->getPost('password');
            if (!empty($password)) {
               $user->password = md5($password);
            }

            if ($user->save()) {
               $this->flashSession->notice("User berhasil diupdate");
            } else {
               foreach ($user->getMessages() as $message) {
                  $this->flashSession->error($message->getMessage());
               }
            }
         }
      }
      return $this->response->redirect('settings/user');
   }

   public function userDeleteAction($id)
   {
      $this->view->disable();
      $user = User::findFirstById($id);
      if ($user) {
         if ($user->delete()) {
            $this->flashSession->notice("User berhasil dihapus");
         } else {
            foreach ($user->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('settings/user');
   }

   /**
    * Promotion Management
    */
   public function promotionAction()
   {
      $this->view->setVar("title", "Promotion Management");
      $discounts = Discount::find([
         "order" => "valid_from DESC"
      ]);
      $this->view->discounts = $discounts;
   }

   public function promotionStoreAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $discount = new Discount();
         $discount->name        = $this->request->getPost('name');
         $discount->type        = $this->request->getPost('type');
         $discount->value       = $this->request->getPost('value');
         $discount->valid_from  = $this->request->getPost('valid_from');
         $discount->valid_until = $this->request->getPost('valid_until');

         if ($discount->save()) {
            $this->flashSession->notice("Promo berhasil ditambahkan");
         } else {
            foreach ($discount->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('settings/promotion');
   }

   public function promotionUpdateAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $id = $this->request->getPost('id');
         $discount = Discount::findFirstById($id);
         if ($discount) {
            $discount->name        = $this->request->getPost('name');
            $discount->type        = $this->request->getPost('type');
            $discount->value       = $this->request->getPost('value');
            $discount->valid_from  = $this->request->getPost('valid_from');
            $discount->valid_until = $this->request->getPost('valid_until');

            if ($discount->save()) {
               $this->flashSession->notice("Promo berhasil diupdate");
            } else {
               foreach ($discount->getMessages() as $message) {
                  $this->flashSession->error($message->getMessage());
               }
            }
         }
      }
      return $this->response->redirect('settings/promotion');
   }

   public function promotionDeleteAction($id)
   {
      $this->view->disable();
      $discount = Discount::findFirstById($id);
      if ($discount) {
         if ($discount->delete()) {
            $this->flashSession->notice("Promo berhasil dihapus");
         } else {
            foreach ($discount->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('settings/promotion');
   }
}
