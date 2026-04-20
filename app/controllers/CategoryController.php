<?php

use Phalcon\Mvc\Controller;

class CategoryController extends Controller
{
   public function indexAction()
   {
      $this->view->setVar("title", "Categories");

      $categories = $this->modelsManager->createBuilder()
         ->from(['c' => 'Category'])
         ->columns([
            'c.id',
            'c.name',
            'c.description',
            'c.is_active',
            'c.sort_order',
            'COUNT(p.id) as total_products'
         ])
         ->leftJoin('Product', 'p.category_id = c.id', 'p')
         ->groupBy('c.id, c.name, c.description, c.is_active, c.sort_order')
         ->orderBy('c.sort_order')
         ->getQuery()
         ->execute();

      $this->view->categories = $categories;
   }

   public function storeAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $category = new Category();
         $category->name        = $this->request->getPost('name');
         $category->description = $this->request->getPost('description');
         $category->is_active   = $this->request->getPost('is_active') ? 'Y' : 'N';
         $category->sort_order  = $this->request->getPost('sort_order');

         if ($category->save()) {
            $this->flashSession->success("Category berhasil ditambahkan");
         } else {
            foreach ($category->getMessages() as $message) {
               $this->flashSession->error($message->getMessage());
            }
         }
      }
      return $this->response->redirect('category');
   }

   public function updateAction()
   {
      $this->view->disable();
      if ($this->request->isPost()) {
         $id = $this->request->getPost('id');
         $category = Category::findFirstById($id);
         if ($category) {
            $category->name        = $this->request->getPost('name');
            $category->description = $this->request->getPost('description');
            $category->is_active   = $this->request->getPost('is_active') ? 'Y' : 'N';
            $category->sort_order  = $this->request->getPost('sort_order');

            if ($category->save()) {
               $this->flashSession->success("Category berhasil diupdate");
            } else {
               foreach ($category->getMessages() as $message) {
                  $this->flashSession->error($message->getMessage());
               }
            }
         }
      }
      return $this->response->redirect('category');
   }

   public function deleteAction()
   {
      $this->view->disable();
      
      if ($this->request->isPost()) {
         $id = $this->request->getPost('id');
         $category = Category::findFirstById($id);
         if ($category) {
            if ($category->delete()) {
               $this->flashSession->success("Category berhasil dihapus");
            } else {
               foreach ($category->getMessages() as $message) {
                  $this->flashSession->error($message->getMessage());
               }
            }
         }
         return $this->response->redirect('category');
      }
   }
}