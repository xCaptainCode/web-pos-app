<div class="content-header">
   <div class="container">
      <div class="row mb-2">
         <div class="col-sm-6">
            <h1 class="m-0">{{ title }}</h1>
         </div>
         <div class="col-sm-6 small">
            <ol class="breadcrumb float-sm-right">
               <li class="breadcrumb-item"><a href="#">Home</a></li>
               <li class="breadcrumb-item active">{{ title }}</li>
            </ol>
         </div>
      </div>
   </div>
</div>

<!-- content -->
<div class="content">
   <div class="container">
      <div class="row form-group">
         <div class="col-12 col-md-12 col-lg-12 text-md-right">
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#modalAddCategory">
               <i class="fas fa-plus"></i> Tambah Category
            </button>
         </div>
      </div>
      <div class="row">
         <div class="col-md-12">
            <div class="card card-outline card-primary">
               <div class="card-header">
                  <h3 class="card-title">Daftar {{ title }}</h3>
               </div>
               <div class="card-body">
                  <table id="example1" class="table table-sm table-bordered table-striped table-hover">
                     <thead class="text-center">
                        <tr>
                           <th>No</th>
                           <th>Name</th>
                           <th>Description</th>
                           <th>Status</th>
                           <th>Sort Order</th>
                           <th>Total Product</th>
                           <th>Action</th>
                        </tr>
                     </thead>
                     <tbody>
                        {% for category in categories %}
                        <tr>
                           <td class="text-center">{{ loop.index }}</td>
                           <td class="text-left">{{ category.name }}</td>
                           <td class="text-left">{{ category.description }}</td>
                           <td class="text-center">
                              {% if category.is_active == 'Y' %}
                              <span class="badge badge-success">Aktif</span>
                              {% else %}
                              <span class="badge badge-danger">Tidak Aktif</span>
                              {% endif %}
                           </td>
                           <td class="text-center">{{ category.sort_order }}</td>
                           <td class="text-center">
                              <span class="badge badge-info">{{ category.total_products }}</span>
                           </td>
                           <td class="text-center">
                              <div class="btn-group">
                                 <a href="#" data-toggle="modal" data-target="#modal-edit" data-id="{{ category.id }}"
                                    data-name="{{ category.name }}" data-description="{{ category.description }}"
                                    data-is_active="{{ category.is_active }}"
                                    data-sort_order="{{ category.sort_order }}" class="btn btn-xs btn-warning"
                                    title="Edit">
                                    <i class="fas fa-edit"></i>
                                    Edit
                                 </a>
                                 <a href="#" data-toggle="modal" data-target="#modal-delete" data-id="{{ category.id }}"
                                    data-name="{{ category.name }}" class="btn btn-xs btn-danger" title="Delete">
                                    <i class="fas fa-trash-alt"></i>
                                    Delete
                                 </a>
                              </div>
                           </td>
                        </tr>
                        {% endfor %}
                     </tbody>
                  </table>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>

<!-- modal add category -->
<div class="modal fade" id="modalAddCategory">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-primary">
            <h4 class="modal-title">Tambah Category</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formAdd" action="{{ url('category/store') }}" method="post">
               <div class="form-group">
                  <label for="name">Name</label>
                  <input type="text" name="name" id="name" class="form-control form-control-sm upper-case" required>
                  <span class="text-danger small nameError"></span>
               </div>
               <div class="form-group">
                  <label for="description">Description</label>
                  <textarea name="description" id="description" class="form-control form-control-sm"></textarea>
               </div>
               <div class="form-group">
                  <label for="sort_order">Sort Order</label>
                  <input type="number" name="sort_order" id="sort_order" class="form-control form-control-sm" required>
               </div>
               <div class="form-group">
                  <label for="is_active">Status</label>
                  <select name="is_active" id="is_active" class="form-control form-control-sm" required>
                     <option value="Y">Aktif</option>
                     <option value="N">Tidak Aktif</option>
                  </select>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Batal</button>
            <button type="submit" class="btn btn-success btn-sm" form="formAdd"><i class="fas fa-save"></i> Tambah
               Kategori</button>
         </div>
      </div>
   </div>
</div>

<!-- modal edit category -->
<div class="modal fade" id="modal-edit">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-warning">
            <h4 class="modal-title">Edit Category</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formEdit" action="{{ url('category/update') }}" method="post">
               <input type="hidden" name="id" id="edit_id">
               <div class="form-group">
                  <label for="edit_name">Name</label>
                  <input type="text" name="name" id="edit_name" class="form-control form-control-sm upper-case"
                     required>
                  <span class="text-danger small editNameError"></span>
               </div>
               <div class="form-group">
                  <label for="edit_description">Description</label>
                  <textarea name="description" id="edit_description" class="form-control form-control-sm"></textarea>
               </div>
               <div class="form-group">
                  <label for="edit_sort_order">Sort Order</label>
                  <input type="number" name="sort_order" id="edit_sort_order" class="form-control form-control-sm"
                     required>
               </div>
               <div class="form-group">
                  <label for="edit_is_active">Status</label>
                  <select name="is_active" id="edit_is_active" class="form-control form-control-sm" required>
                     <option value="1">Aktif</option>
                     <option value="">Tidak Aktif</option>
                  </select>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Batal</button>
            <button type="submit" class="btn btn-primary btn-sm" form="formEdit"><i class="fas fa-save"></i> Perbarui
               Kategori</button>
         </div>
      </div>
   </div>
</div>

<!-- modal delete category -->
<div class="modal fade" id="modal-delete">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-danger">
            <h4 class="modal-title">Hapus Category</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formDelete" action="{{ url('category/delete') }}" method="post">
               <input type="hidden" name="id" id="delete_id">
               <div class="d-flex align-items-center justify-content-center flex-column">
                  <div class="bg-danger d-flex align-items-center justify-content-center rounded-circle mb-3"
                     style="width: 100px; height: 100px;">
                     <i class="fas fa-trash-alt fa-4x text-white"></i>
                  </div>
                  <div class="form-group text-center">
                     <label>Apakah anda yakin ingin menghapus category </label>
                     <div class="text-bold"><span id="delete_name" class="text-danger"></span>
                        ?</div>
                     <div class="bg-danger p-2 mt-3 rounded shadow-sm">
                        <p class="text-white small mb-0">Data yang sudah terhapus tidak dapat dikembalikan!</p>
                     </div>
                  </div>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-around">
            <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Batal</button>
            <button type="submit" class="btn btn-danger btn-sm" form="formDelete"><i class="fas fa-trash-alt"></i> Ya,
               Hapus!</button>
         </div>
      </div>
   </div>
</div>

<script>
   $(function () {
      $('#example1').DataTable({
         "paging": true,
         "lengthChange": false,
         "searching": true,
         "ordering": true,
         "info": true,
         "autoWidth": false,
         "responsive": true,
         language: {
            search: 'Cari:',
            paginate: {
               previous: '<i class="fas fa-angle-left"></i>',
               next: '<i class="fas fa-angle-right"></i>'
            }
         }
      });
   });
</script>

<script>
   $(document).on('click', '[data-target="#modal-edit"]', function () {
      $('#edit_id').val($(this).data('id'));
      $('#edit_name').val($(this).data('name'));
      $('#edit_description').val($(this).data('description'));
      $('#edit_sort_order').val($(this).data('sort_order'));
      $('#edit_is_active').val($(this).data('is_active'));
   });

   $(document).on('click', '[data-target="#modal-delete"]', function () {
      $('#delete_id').val($(this).data('id'));
      $('#delete_name').text($(this).data('name'));
   });

   // Handle form submission loading state
   $('#formAdd, #formEdit, #formDelete').on('submit', function () {
      var $button = $(this).closest('.modal-content').find('button[type="submit"]');
      $button.prop('disabled', true);
      $button.html('<i class="fa fa-spinner fa-spin" aria-hidden="true"></i> Menyimpan...');
   });
</script>