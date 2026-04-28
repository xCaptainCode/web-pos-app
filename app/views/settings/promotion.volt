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
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#modalAddPromo">
               <i class="fas fa-plus"></i> Tambah Promo
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
                     <table id="dataTable" class="table table-sm table-bordered table-striped table-hover">
                        <thead class="text-center">
                           <tr>
                              <th>No</th>
                              <th>Nama Promo</th>
                              <th>Tipe</th>
                              <th>Nilai</th>
                              <th>Berlaku Dari</th>
                              <th>Hingga</th>
                              <th>Status</th>
                              <th>Action</th>
                           </tr>
                        </thead>
                        <tbody>
                           {% set now = date('Y-m-d') %}
                           {% for promo in discounts %}
                           <tr>
                              <td class="text-center">{{ loop.index }}</td>
                              <td class="text-left">{{ promo.name }}</td>
                              <td class="text-center">
                                 {% if promo.type == 'percentage' %}
                                 <span class="badge badge-info">Percentage</span>
                                 {% else %}
                                 <span class="badge badge-secondary">Fixed Amount</span>
                                 {% endif %}
                              </td>
                              <td class="text-right">
                                 {% if promo.type == 'percentage' %}
                                 {{ promo.value }}%
                                 {% else %}
                                 {{ Helpers.number(promo.value) }}
                                 {% endif %}
                              </td>
                              <td class="text-center">{{ promo.valid_from }}</td>
                              <td class="text-center">{{ promo.valid_until }}</td>
                              <td class="text-center">
                                 {% if now >= promo.valid_from and now <= promo.valid_until %} <span
                                    class="badge badge-success">Aktif</span>
                                    {% elseif now < promo.valid_from %} <span class="badge badge-warning">
                                       Mendatang</span>
                                       {% else %}
                                       <span class="badge badge-danger">Kedaluwarsa</span>
                                       {% endif %}
                              </td>
                              <td class="text-center">
                                 <div class="btn-group">
                                    <a href="#" data-toggle="modal" data-target="#modal-edit" data-id="{{ promo.id }}"
                                       data-name="{{ promo.name }}" data-type="{{ promo.type }}"
                                       data-value="{{ promo.value }}" data-valid_from="{{ promo.valid_from }}"
                                       data-valid_until="{{ promo.valid_until }}" class="btn btn-xs btn-warning">
                                       <i class="fas fa-edit"></i>
                                       Edit
                                    </a>
                                    <a href="#" data-toggle="modal" data-target="#modal-delete" data-id="{{ promo.id }}"
                                       data-name="{{ promo.name }}" class="btn btn-xs btn-danger">
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
</div>

<!-- modal add promo -->
<div class="modal fade" id="modalAddPromo">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-primary">
            <h4 class="modal-title">Tambah Promo</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formAdd" action="{{ url('settings/promotionStore') }}" method="post">
               <div class="form-group">
                  <label for="name">Nama Promo</label>
                  <input type="text" name="name" id="name" class="form-control form-control-sm" required>
               </div>
               <div class="row">
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="type">Tipe</label>
                        <select name="type" id="type" class="form-control form-control-sm" required>
                           <option value="percentage">Percentage (%)</option>
                           <option value="fixed_amount">Fixed Amount</option>
                        </select>
                     </div>
                  </div>
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="value">Nilai</label>
                        <input type="number" name="value" id="value" class="form-control form-control-sm" required>
                     </div>
                  </div>
               </div>
               <div class="row">
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="valid_from">Berlaku Dari</label>
                        <input type="date" name="valid_from" id="valid_from" class="form-control form-control-sm"
                           required>
                     </div>
                  </div>
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="valid_until">Hingga</label>
                        <input type="date" name="valid_until" id="valid_until" class="form-control form-control-sm"
                           required>
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

<!-- modal edit promo -->
<div class="modal fade" id="modal-edit">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header bg-warning">
            <h4 class="modal-title">Edit Promo</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <form id="formEdit" action="{{ url('settings/promotionUpdate') }}" method="post">
               <input type="hidden" name="id" id="id">
               <div class="form-group">
                  <label for="name">Nama Promo</label>
                  <input type="text" name="name" id="name" class="form-control form-control-sm" required>
               </div>
               <div class="row">
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="type">Tipe</label>
                        <select name="type" id="type" class="form-control form-control-sm" required>
                           <option value="percentage">Percentage (%)</option>
                           <option value="fixed_amount">Fixed Amount</option>
                        </select>
                     </div>
                  </div>
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="value">Nilai</label>
                        <input type="number" name="value" id="value" class="form-control form-control-sm" required>
                     </div>
                  </div>
               </div>
               <div class="row">
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="valid_from">Berlaku Dari</label>
                        <input type="date" name="valid_from" id="valid_from" class="form-control form-control-sm"
                           required>
                     </div>
                  </div>
                  <div class="col-md-6">
                     <div class="form-group">
                        <label for="valid_until">Hingga</label>
                        <input type="date" name="valid_until" id="valid_until" class="form-control form-control-sm"
                           required>
                     </div>
                  </div>
               </div>
            </form>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-sm btn-primary" form="formEdit"><i class="fas fa-save"></i> Save
               changes</button>
         </div>
      </div>
   </div>
</div>

<!-- modal delete promo -->
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
            <div class="d-flex align-items-center justify-content-center flex-column">
               <div class="bg-danger d-flex align-items-center justify-content-center rounded-circle mb-3"
                  style="width: 100px; height: 100px;">
                  <i class="fas fa-trash-alt fa-4x text-white"></i>
               </div>
               <p>Apakah Anda yakin ingin menghapus promo <br> <strong id="delete-promo-name"></strong>?</p>
               <div class="bg-danger p-2 rounded shadow-sm">
                  <p class="text-white small mb-0">Data yang sudah terhapus tidak dapat dikembalikan!</p>
               </div>
            </div>
         </div>
         <div class="modal-footer justify-content-around">
            <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">Batal</button>
            <a href="#" id="btn-confirm-delete" class="btn btn-danger btn-sm"><i class="fas fa-trash-alt"></i> Ya, Hapus!</a>
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
         var type = button.data('type');
         var value = button.data('value');
         var valid_from = button.data('valid_from');
         var valid_until = button.data('valid_until');

         var modal = $(this);
         modal.find('#id').val(id);
         modal.find('.modal-body #name').val(name);
         modal.find('.modal-body #type').val(type);
         modal.find('.modal-body #value').val(value);
         modal.find('.modal-body #valid_from').val(valid_from);
         modal.find('.modal-body #valid_until').val(valid_until);
      });

      // Delete modal population
      $('#modal-delete').on('show.bs.modal', function (event) {
         var button = $(event.relatedTarget);
         var id = button.data('id');
         var name = button.data('name');

         var modal = $(this);
         modal.find('#delete-promo-name').text(name);
         modal.find('#btn-confirm-delete').attr('href', '{{ url("settings/promotionDelete/") }}' + id);
      });

      // Date validation
      $('#formAdd, #formEdit').on('submit', function (e) {
         var validFrom = $(this).find('input[name="valid_from"]').val();
         var validUntil = $(this).find('input[name="valid_until"]').val();

         // if (validUntil < validFrom) {
         //    e.preventDefault();
         //    alert('Tanggal berakhir tidak boleh lebih kecil dari tanggal mulai!');
         //    return false;
         // }

         var $button = $(this).closest('.modal-content').find('button[type="submit"]');
         $button.prop('disabled', true);
         $button.html('<i class="fa fa-spinner fa-spin" aria-hidden="true"></i> Menyimpan...');
      });
   });
</script>