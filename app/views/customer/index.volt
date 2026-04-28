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
               <i class="fas fa-plus"></i> Tambah Customer
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
                           <th>Phone</th>
                           <th>Points</th>
                           <th>Total Spent</th>
                           <th>Action</th>
                        </tr>
                     </thead>
                     <tbody>
                        {% for customer in customers %}
                        <tr>
                           <td class="text-center">{{ loop.index }}</td>
                           <td class="text-left">{{ customer.name }}</td>
                           <td class="text-left text-number">{{ customer.phone }}</td>
                           <td class="text-center">
                              {% if customer.loyality_points %}
                              <span class="badge badge-default bg-indigo badge-pill">{{ customer.loyality_points }}</span>
                              {% else %}
                              <span class="badge badge-danger badge-pill">0</span>
                              {% endif %}
                           </td>
                           <td class="text-right text-number">Rp {{ Helpers.number(customer.total_spent) }}</td>
                           <td class="text-center">
                              <div class="btn-group">
                                 <!-- detail -->
                                 <a href="{{ url('customer/history/') ~ customer.id }}" class="btn btn-xs btn-info" title="Detail">
                                    <i class="fas fa-info-circle"></i>
                                    Detail
                                 </a>
                                 <!-- edit -->
                                 <a href="#" data-toggle="modal" data-target="#modal-edit" data-id="{{ customer.id }}"
                                    data-name="{{ customer.name }}" data-phone="{{ customer.phone }}"
                                    data-loyality_points="{{ customer.loyality_points }}"
                                    data-total_spent="{{ customer.total_spent }}" class="btn btn-xs btn-warning" title="Edit">
                                    <i class="fas fa-edit"></i>
                                    Edit
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

<!-- modal add customer -->
<div class="modal fade" id="modalAddCategory">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-primary">
            <h4 class="modal-title">Tambah Customer</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formAdd" action="{{ url('customer/store') }}" method="post">
               <div class="form-group">
                  <label for="name">Name</label>
                  <input type="text" name="name" id="name" class="form-control form-control-sm" required>
                  <span class="text-danger small nameError"></span>
               </div>
               <div class="form-group">
                  <label for="phone">Phone</label>
                  <input type="text" name="phone" id="phone" class="form-control form-control-sm" required>
                  <span class="text-danger small phoneError"></span>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Batal</button>
            <button type="submit" class="btn btn-success btn-sm" form="formAdd"><i class="fas fa-save"></i> Tambah
               Customer</button>
         </div>
      </div>
   </div>
</div>

<!-- modal edit customer -->
<div class="modal fade" id="modal-edit">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-warning">
            <h4 class="modal-title">Edit Customer</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formEdit" action="{{ url('customer/update') }}" method="post">
               <input type="hidden" name="id" id="edit_id">
               <div class="form-group">
                  <label for="edit_name">Name</label>
                  <input type="text" name="name" id="edit_name" class="form-control form-control-sm" required>
                  <span class="text-danger small editNameError"></span>
               </div>
               <div class="form-group">
                  <label for="edit_phone">Phone</label>
                  <input type="text" name="phone" id="edit_phone" class="form-control form-control-sm" required>
                  <span class="text-danger small editPhoneError"></span>
               </div>
               <div class="form-group">
                  <label for="edit_loyality_points">Loyality Points</label>
                  <input type="number" name="loyality_points" id="edit_loyality_points"  class="form-control form-control-sm">
               </div>
               <div class="form-group">
                  <label for="edit_total_spent">Total Spent</label> 
                  <input type="number" name="total_spent" id="edit_total_spent" class="form-control form-control-sm">
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Batal</button>
            <button type="submit" class="btn btn-primary btn-sm" form="formEdit"><i class="fas fa-save"></i> Perbarui
               Customer</button>
         </div>
      </div>
   </div>
</div>

<!-- modal delete customer -->
<div class="modal fade" id="modal-delete">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-danger">
            <h4 class="modal-title">Hapus Customer</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formDelete" action="{{ url('customer/delete') }}" method="post">
               <input type="hidden" name="id" id="delete_id">
               <div class="form-group text-center">
                  <label>Apakah anda yakin ingin menghapus customer </label>
                  <div class="text-bold"><span id="delete_name" class="text-danger"></span>
                     ?</div>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-around">
            <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Batal</button>
            <button type="submit" class="btn btn-danger btn-sm" form="formDelete"><i class="fas fa-trash"></i> Ya, Hapus!</button>
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
      $('#edit_phone').val($(this).data('phone'));
      $('#edit_loyality_points').val($(this).data('loyality_points'));
      $('#edit_total_spent').val($(this).data('total_spent'));
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