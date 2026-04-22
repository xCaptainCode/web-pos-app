<style>
   .seamless-group:focus-within {
      box-shadow: 0 0 0 0.05rem rgba(0, 123, 255, 0.25);
      border-radius: 0.25rem;
   }

   .seamless-group:focus-within .form-control,
   .seamless-group:focus-within .btn {
      border-color: #80bdff !important;
   }

   .seamless-group .form-control:focus {
      box-shadow: none;
      border-color: #ced4da;
   }

   #pwdVisibilityAdd,
   #pwdVisibilityEdit {
      border-color: #ced4da;
      transition: all 0.2s;
   }

   #pwdVisibilityAdd:hover i,
   #pwdVisibilityEdit:hover i {
      color: #333 !important;
   }
</style>

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

<!-- content  -->
<div class="content">
   <div class="container">
      <div class="row form-group">
         <div class="col-12 col-md-12 col-lg-12 text-md-right">
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#modalAddUser">
               <i class="fas fa-plus"></i> Tambah User
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
                  <div class="table-responsive">
                     <table id="example1" class="table table-sm table-bordered table-striped table-hover">
                        <thead class="text-center">
                           <tr>
                              <th>No</th>
                              <th>Name</th>
                              <th>Username</th>
                              <th>Role</th>
                              <th>Status</th>
                              <th>Action</th>
                           </tr>
                        </thead>
                        <tbody>
                           {% for user in users %}
                           <tr>
                              <td class="text-center">{{ loop.index }}</td>
                              <td class="text-left">{{ user.name }}</td>
                              <td class="text-left">{{ user.username }}</td>
                              <td class="text-center">{{ user.role }}</td>
                              <td class="text-center">
                                 {% if user.is_active == 'Y' %}
                                 <span class="badge badge-success">Aktif</span>
                                 {% else %}
                                 <span class="badge badge-danger">Tidak Aktif</span>
                                 {% endif %}
                              </td>
                              <td class="text-center">
                                 <a href="#" data-toggle="modal" data-target="#modal-edit" data-id="{{ user.id }}"
                                    data-name="{{ user.name }}" data-username="{{ user.username }}"
                                    data-role="{{ user.role }}" data-is_active="{{ user.is_active }}"
                                    class="btn btn-xs btn-warning">
                                    <i class="fas fa-edit"></i>
                                    Edit
                                 </a>
                                 <a href="#" data-toggle="modal" data-target="#modal-delete" data-id="{{ user.id }}"
                                    data-name="{{ user.name }}" class="btn btn-xs btn-danger">
                                    <i class="fas fa-trash-alt"></i>
                                    Delete
                                 </a>
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
</div>

<!-- modal add user -->
<div class="modal fade" id="modalAddUser">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-primary">
            <h4 class="modal-title">Tambah User</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formAdd" action="{{ url('user/store') }}" method="post">
               <div class="form-group">
                  <label for="name">Name</label>
                  <input type="text" name="name" id="name" class="form-control form-control-sm" required>
                  <span class="text-danger small nameError"></span>
               </div>
               <div class="form-group">
                  <label for="role">Role</label>
                  <select name="role" id="role" class="form-control form-control-sm" required>
                     <option value="ADMIN">ADMIN</option>
                     <option value="USER">USER</option>
                  </select>
               </div>
               <div class="form-group">
                  <label for="username">Username</label>
                  <input type="text" name="username" id="username" class="form-control form-control-sm inputUsername" required>
                  <span class="text-danger small usernameError"></span>
               </div>
               <div class="form-group">
                  <label for="inputPasswordAdd">Password</label>
                  <div class="input-group input-group-sm seamless-group">
                     <input type="password" class="form-control border-right-0" id="inputPasswordAdd" name="password"
                        placeholder="Password" required>
                     <div class="input-group-append">
                        <button type="button" id="pwdVisibilityAdd" class="btn border-left-0 shadow-none">
                           <i class="fas fa-eye text-muted" id="eyeIconAdd"></i>
                        </button>
                     </div>
                  </div>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-sm btn-primary" form="formAdd"><i class="fas fa-save"></i> 
               Save</button>
         </div>
      </div>
   </div>
</div>

<div class="modal fade" id="modal-edit">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-warning">
            <h4 class="modal-title">Edit User</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formEdit" action="{{ url('user/update') }}" method="post">
               <input type="hidden" name="id" id="id">
               <div class="form-group">
                  <label for="name">Name</label>
                  <input type="text" name="name" id="name" class="form-control form-control-sm">
               </div>
               <div class="form-group">
                  <label for="role">Role</label>
                  <select name="role" id="role" class="form-control form-control-sm" required>
                     <option value="ADMIN">ADMIN</option>
                     <option value="USER">USER</option>
                  </select>
               </div>
               <div class="form-group">
                  <label for="is_active">Status</label>
                  <select name="is_active" id="is_active" class="form-control form-control-sm" required>
                     <option value="1">Aktif</option>
                     <option value="">Tidak Aktif</option>
                  </select>
               </div>
               <div class="form-group">
                  <label for="username">Username</label>
                  <input type="text" name="username" id="username" class="form-control form-control-sm inputUsername">
                  <span class="text-danger small usernameError"></span>
               </div>
               <div class="form-group">
                  <label for="inputPasswordEdit">New Password</label>
                  <div class="input-group input-group-sm seamless-group">
                     <input type="password" class="form-control border-right-0" id="inputPasswordEdit" name="password"
                        placeholder="Password">
                     <div class="input-group-append">
                        <button type="button" id="pwdVisibilityEdit" class="btn border-left-0 shadow-none">
                           <i class="fas fa-eye text-muted" id="eyeIconEdit"></i>
                        </button>
                     </div>
                  </div>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-sm btn-primary" form="formEdit"><i class="fas fa-save"></i> 
               Save changes</button>
         </div>
      </div>
   </div>
</div>

<!-- modal delete user -->
<div class="modal fade" id="modal-delete">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-danger">
            <h4 class="modal-title">Konfirmasi Hapus</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body text-center">
            <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
            <p>Apakah Anda yakin ingin menghapus user <strong id="delete-user-name"></strong>?</p>
            <p class="text-muted small">Tindakan ini tidak dapat dibatalkan.</p>
         </div>
         <div class="modal-footer justify-content-around">
            <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">Batal</button>
            <a href="#" id="btn-confirm-delete" class="btn btn-danger btn-sm"><i class="fas fa-trash"></i> Hapus</a>
         </div>
      </div>
   </div>
</div>


<script>
   $(document).ready(function () {
      // Edit modal population
      $('#modal-edit').on('show.bs.modal', function (event) {
         var button = $(event.relatedTarget);
         var id = button.data('id');
         var name = button.data('name');
         var username = button.data('username');
         var role = button.data('role');
         var is_active = button.data('is_active');

         var modal = $(this);
         modal.find('#id').val(id);
         modal.find('.modal-body #name').val(name);
         modal.find('.modal-body #username').val(username);
         modal.find('.modal-body #role').val(role);
         modal.find('.modal-body #is_active').val(is_active);
         modal.find('#inputPasswordEdit').val(''); // Clear password field
      });

      // Delete modal population
      $('#modal-delete').on('show.bs.modal', function (event) {
         var button = $(event.relatedTarget);
         var id = button.data('id');
         var name = button.data('name');

         var modal = $(this);
         modal.find('#delete-user-name').text(name);
         modal.find('#btn-confirm-delete').attr('href', '{{ url("user/delete/") }}' + id);
      });

      // Handle form submission loading state
      $('#formAdd, #formEdit').on('submit', function () {
         var $button = $(this).closest('.modal-content').find('button[type="submit"]');
         $button.prop('disabled', true);
         $button.html('<i class="fa fa-spinner fa-spin" aria-hidden="true"></i> Menyimpan...');
      });
   });
</script>

<script>
   // toggle password btn visibility
   $(document).ready(function () {
      $('#pwdVisibilityAdd').on('click', function () {
         var input = $('#inputPasswordAdd');
         var icon = $('#eyeIconAdd');
         if (input.attr('type') == 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
         } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
         }
      });

      $('#pwdVisibilityEdit').on('click', function () {
         var input = $('#inputPasswordEdit');
         var icon = $('#eyeIconEdit');
         if (input.attr('type') == 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
         } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
         }
      });
   });

   // Simple validation
   $(document).ready(function () {
      $('#formAdd input[name="name"], #formEdit input[name="name"]').on('input change', function () {
         if ($(this).val() == '') {
            $(this).addClass('is-invalid');
         } else {
            $(this).removeClass('is-invalid');
         }
      });
      
      $('.inputUsername').on('input change', function () {
         if ($(this).val() == '') {
            $(this).addClass('is-invalid');
            $(this).siblings('.usernameError').text('Username is required');
         } else {
            $(this).removeClass('is-invalid');
            $(this).siblings('.usernameError').text('');
         }
      });
   });
</script>
