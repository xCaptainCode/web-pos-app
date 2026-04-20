<?php

use Phalcon\Mvc\Controller;

class UserController extends Controller
{
   public function indexAction()
   {
      $this->view->setVar("title", "Users");

      $users = User::find([
         "order" => "name ASC"
      ]);

      $this->view->users = $users;
   }

   public function storeAction()
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
            $this->flashSession->success("User berhasil ditambahkan");
         } else {
            foreach ($user->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('user');
   }

   public function updateAction()
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
               $this->flashSession->success("User berhasil diupdate");
            } else {
               foreach ($user->getMessages() as $message) {
                  $this->flashSession->error($message->getMessage());
               }
            }
         }
      }
      return $this->response->redirect('user');
   }

   public function deleteAction($id)
   {
      $this->view->disable();
      $user = User::findFirstById($id);
      if ($user) {
         if ($user->delete()) {
            $this->flashSession->success("User berhasil dihapus");
         } else {
            foreach ($user->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('user');
   }
}