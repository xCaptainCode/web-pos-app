<div class="content-header">
   <div class="container">
      <div class="row mb-2">
         <div class="col-sm-6">
            <h1 class="m-0 text-dark">Riwayat Transaksi</h1>
         </div>
         <div class="col-sm-6 small">
            <ol class="breadcrumb float-sm-right">
               <li class="breadcrumb-item"><a href="{{ url('index') }}">Dashboard</a></li>
               <li class="breadcrumb-item active">Riwayat Transaksi</li>
            </ol>
         </div>
      </div>
   </div>
</div>

<section class="content">
   <div class="container">
      <!-- Filter Card -->
      <div class="card card-outline card-primary shadow-sm">
         <div class="card-body">
            <form method="GET" action="{{ url('transaction/index') }}" class="row align-items-end">
               <div class="col-md-2 mb-2 mb-md-0 font-weight-bold">
                  <i class="fa-solid fa-filter mr-1"></i> Filter Transaksi
               </div>
               <div class="input-group col-md-4 mb-2 mb-md-0">
                  <div class="input-group-prepend">
                     <span class="input-group-text">
                        <i class="far fa-calendar-alt"></i>
                     </span>
                  </div>
                  <input type="text" id="date-range" class="form-control form-control-sm"
                     placeholder="Pilih rentang tanggal">
               </div>
               <input type="hidden" name="date_from" value="{{ filters.date_from }}">
               <input type="hidden" name="date_to" value="{{ filters.date_to }}">
               <div class="col-md-3 mb-2 mb-md-0">
                  {# <label class="small font-weight-bold text-uppercase text-muted">Status</label> #}
                  <select name="status" class="form-control form-control-sm">
                     <option value="">Semua Status</option>
                     <option value="paid" {{ filters.status=='paid' ? 'selected' : '' }}>Paid</option>
                     <option value="pending" {{ filters.status=='pending' ? 'selected' : '' }}>Pending</option>
                     <option value="cancelled" {{ filters.status=='cancelled' ? 'selected' : '' }}>Cancelled</option>
                     <option value="refunded" {{ filters.status=='refunded' ? 'selected' : '' }}>Refunded</option>
                  </select>
               </div>
               <div class="col-md-3 mb-2 mb-md-0">
                  {# <label class="small font-weight-bold text-uppercase text-muted">Kasir</label> #}
                  <select name="user_id" class="form-control form-control-sm select2">
                     <option value="">Semua Kasir</option>
                     {% for cashier in cashiers %}
                     <option value="{{ cashier.id }}" {{ filters.user_id==cashier.id ? 'selected' : '' }}>{{
                        cashier.name }}</option>
                     {% endfor %}
                  </select>
               </div>

            </form>
         </div>
      </div>
      <!-- Transactions Table -->
      <div class="card shadow-sm border-0">
         <div class="card-header">
            <h3 class="card-title">Daftar Transaksi</h3>
            <div class="card-tools" id="dataRiwayat_wrapper"></div>
         </div>
         <div class="card-body p-2">
            <div class="table-responsive">
               <table id="dataRiwayat" class="table table-sm table-hover table-striped ">
                  <thead>
                     <tr>
                        <th class="border-top-0">Waktu</th>
                        <th class="border-top-0">Order No</th>
                        <th class="border-top-0">Customer</th>
                        <th class="border-top-0">Kasir</th>
                        <th class="border-top-0 text-right">Total</th>
                        <th class="border-top-0 text-center">Status</th>
                        <th class="border-top-0 text-center">Aksi</th>
                     </tr>
                  </thead>
                  <tbody>
                     {% set total = 0 %}
                     {% if orders|length > 0 %}
                     {% for order in orders %}
                     <tr>
                        <td class="align-middle">
                           {{ Helpers.formatDateTime(order.created_at, 'd-M-Y H:i') }}
                        </td>
                        <td class="align-middle">
                           <span class="badge badge-light border text-monospace px-2 py-1">{{ order.order_no }}</span>
                        </td>
                        <td class="align-middle font-weight-bold">{{ order.customer_name }}</td>
                        <td class="align-middle">{{ order.cashier_name }}</td>
                        <td class="align-middle text-right font-weight-bold text-success text-number">Rp {{
                           Helpers.number(order.total) }}</td>
                        <td class="align-middle text-center">
                           {% if order.status == 'paid' %}
                           <span class="badge badge-success px-3 py-1">PAID</span>
                           {% elseif order.status == 'cancelled' %}
                           <span class="badge badge-danger px-3 py-1">CANCELLED</span>
                           {% elseif order.status == 'refunded' %}
                           <span class="badge badge-warning px-3 py-1 text-white">REFUNDED</span>
                           {% else %}
                           <span class="badge badge-secondary px-3 py-1">{{ order.status|upper }}</span>
                           {% endif %}
                        </td>
                        <td class="align-middle text-center">
                           <div class="btn-group shadow-sm">
                              <button type="button" class="btn btn-sm btn-info btn-detail" data-id="{{ order.id }}"
                                 data-order-no="{{ order.order_no }}" title="Detail">
                                 <i class="fa-solid fa-info-circle"></i>
                              </button>
                              {# <a href="{{ url('transaction/print/' ~ order.id) }}" target="_blank"
                                 class="btn btn-sm btn-default border" title="Cetak Struk">
                                 <i class="fa-solid fa-print"></i>
                              </a> #}
                              {% if order.status == 'paid' %}
                              <button type="button" class="btn btn-sm btn-warning btn-refund" data-id="{{ order.id }}"
                                 data-no="{{ order.order_no }}" title="Refund">
                                 <i class="fa-solid fa-rotate-left"></i>
                              </button>
                              <button type="button" class="btn btn-sm btn-danger btn-void" data-id="{{ order.id }}"
                                 data-no="{{ order.order_no }}" title="Void / Cancel">
                                 <i class="fa-solid fa-ban"></i>
                              </button>
                              {% else %}
                              <button type="button" class="btn btn-sm btn-secondary" disabled>
                                 <i class="fa-solid fa-rotate-left"></i>
                              </button>
                              <button type="button" class="btn btn-sm btn-secondary" disabled>
                                 <i class="fa-solid fa-ban"></i>
                              </button>
                              {% endif %}
                           </div>
                        </td>
                     </tr>
                     {% set total += order.total %}
                     {% endfor %}
                     {% else %}
                     <tr>
                        <td colspan="7" class="text-center py-5 text-muted">
                           <i class="fa-solid fa-receipt fa-3x mb-3 d-block opacity-25"></i>
                           <h5>Tidak ada transaksi ditemukan</h5>
                           <p class="small">Coba ubah filter atau rentang tanggal Anda.</p>
                        </td>
                     </tr>
                     {% endif %}
                  </tbody>
                  <tfoot class="table-light">
                     <tr>
                        <th colspan="4" class="text-right font-weight-bold">Total Transaksi</th>
                        <th class="text-right"><h5 class="font-weight-bold text-primary text-number">Rp {{ Helpers.number(total) }}</h5></th>
                        <th></th>
                        <th></th>
                     </tr>
                  </tfoot>
               </table>
            </div>
         </div>
      </div>
   </div>
</section>

<!-- Modal Order Detail -->
<div class="modal fade" id="modalOrderDetail">
   <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
         <div class="modal-header">
            <h4 class="modal-title">Detail Order: <span id="detail_order_no"></span></h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body" id="detail_content">
            <div class="text-center p-4">
               <i class="fas fa-spinner fa-spin fa-2x"></i>
               <p>Memuat data...</p>
            </div>
         </div>
         <div class="modal-footer justify-content-end">
            <button type="button" class="btn btn-default" data-dismiss="modal">Tutup</button>
         </div>
      </div>
   </div>
</div>

<script>
   $(document).ready(function () {

      var start = moment("{{ filters.date_from }}");
      var end = moment("{{ filters.date_to }}");

      function cb(start, end) {
         $('#date-range').val(start.format('DD-MMM-YYYY') + ' - ' + end.format('DD-MMM-YYYY'));
         $('input[name="date_from"]').val(start.format('YYYY-MM-DD'));
         $('input[name="date_to"]').val(end.format('YYYY-MM-DD'));
      }

      $('#date-range').daterangepicker({
         startDate: start,
         endDate: end,
         autoUpdateInput: false,
         locale: {
            format: 'DD-MMM-YYYY',
            applyLabel: 'Pilih',
            cancelLabel: 'Batal',
            fromLabel: 'Dari',
            toLabel: 'Sampai',
            customRangeLabel: 'Kustom',
            daysOfWeek: ['Mg', 'Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb'],
            monthNames: ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
               'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember']
         },
         ranges: {
            'Hari Ini': [moment(), moment()],
            'Kemarin': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
            '7 Hari Terakhir': [moment().subtract(6, 'days'), moment()],
            '30 Hari Terakhir': [moment().subtract(29, 'days'), moment()],
            'Bulan Ini': [moment().startOf('month'), moment().endOf('month')],
            'Bulan Lalu': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
         },
         opens: 'right',
         drops: 'auto'
      }, cb);

      cb(start, end);

      $('#date-range').on('apply.daterangepicker', function (ev, picker) {
         cb(picker.startDate, picker.endDate);
         $(this).closest('form').submit();
      });


      var table = $('#dataRiwayat').DataTable({
         "buttons": [
            {
               "extend": 'copy',
               "text": '<i class="fas fa-copy"></i> Copy',
               "className": 'btn btn-secondary btn-sm'
            },
            {
               "extend": 'excel',
               "text": '<i class="fas fa-file-excel"></i> Excel',
               "className": 'btn btn-success btn-sm'
            },  
            {
               "extend": 'csv',
               "text": '<i class="fas fa-file-csv"></i> CSV',
               "className": 'btn btn-info btn-sm'
            },
            {
               "extend": 'pdf',
               "text": '<i class="fas fa-file-pdf"></i> PDF',
               "className": 'btn btn-danger btn-sm'
            },
            {
               "extend": 'print',
               "text": '<i class="fas fa-print"></i> Print',
               "className": 'btn btn-warning btn-sm'
            },
            {
               "extend": 'colvis',
               "text": '<i class="fas fa-table"></i> Column Visibility',
               "className": 'btn btn-secondary btn-sm'
            }
         ],
         "format": ['F4', 'margin_top 25', 'margin_bottom 25', 'margin_left 25', 'margin_right 25'],
         "paging": true,
         "lengthChange": true,
         "searching": true,
         "ordering": true,
         "info": true,
         "autoWidth": false,
         "responsive": true,
         "order": [[1, "desc"]],
         "language": {
            "search": 'Cari:',
            "paginate": {
               "previous": '<i class="fas fa-angle-left"></i>',
               "next": '<i class="fas fa-angle-right"></i>'
            }
         },
      });

      table.buttons().container().appendTo('#dataRiwayat_wrapper');

      // Initialize Select2 if available
      if ($.fn.select2) {
         $('.select2').select2({
            width: '100%'
         }).on('change', function() {
            $(this).closest('form').submit();
         });
      }

      // Status change auto submit
      $('select[name="status"]').on('change', function() {
         $(this).closest('form').submit();
      });

      let currentOrderId = null;

      $('#dataRiwayat').on('click', '.btn-detail', function () {
         currentOrderId = $(this).data('id');
         var orderId = currentOrderId;
         var orderNo = $(this).data('order-no');

         $('#detail_order_no').text(orderNo);
         $('#modalOrderDetail').modal('show');
         $('#detail_content').html('<div class="text-center p-4"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Memuat data...</p></div>');

         $.ajax({
            url: '{{ url("order/getDetailJson/") }}' + orderId,
            type: 'GET',
            dataType: 'json',
            success: function (response) {
               if (response.success) {
                  var order = response.order;
                  var items = response.items;

                  var statusClass = 'badge-secondary';
                  if (order.status === 'paid') statusClass = 'badge-success';
                  if (order.status === 'pending') statusClass = 'badge-warning';
                  if (order.status === 'cancel') statusClass = 'badge-danger';

                  var customerName = order.customer_name + (order.customer_phone ? ' (' + order.customer_phone + ')' : '');
                  var createdAt = "{{ Helpers.formatDateTime(order.created_at, 'l, d M Y H:i') }}";

                  var html = '<div class="row mb-3">' +
                     '  <div class="col-md-6">' +
                     '     <table class="table table-sm table-borderless mb-0">' +
                     '        <tr><th width="120">Kasir</th><td>' + order.cashier_name + '</td></tr>' +
                     '        <tr><th>Customer</th><td>' + customerName + '</td></tr>' +
                     '        <tr><th>Status</th><td><span class="badge ' + statusClass + '">' + order.status.toUpperCase() + '</span></td></tr>' +
                     '        <tr><th>Waktu</th><td>' + createdAt + '</td></tr>' +
                     '     </table>' +
                     '  </div>' +
                     '  <div class="col-md-6">' +
                     '     <table class="table table-sm table-borderless mb-0">' +
                     '        <tr><th width="120">Subtotal</th><td>Rp ' + Number(order.subtotal).toLocaleString('id-ID') + '</td></tr>' +
                     '        <tr><th>Discount</th><td>Rp ' + Number(order.discount).toLocaleString('id-ID') + '</td></tr>' +
                     '        <tr><th>Tax</th><td>Rp ' + Number(order.tax).toLocaleString('id-ID') + '</td></tr>' +
                     '        <tr><th>Total</th><td><strong>Rp ' + Number(order.total).toLocaleString('id-ID') + '</strong></td></tr>' +
                     '     </table>' +
                     '  </div>' +
                     '</div>';

                  html += '<div class="table-responsive">' +
                     '<table class="table table-sm table-striped mb-0">' +
                     '<thead>' +
                     '<tr>' +
                     '<th>Produk</th>' +
                     '<th class="text-right">Qty</th>' +
                     '<th class="text-right">Harga Satuan</th>' +
                     '<th class="text-right">Diskon</th>' +
                     '<th class="text-right">Subtotal</th>' +
                     '</tr>' +
                     '</thead>' +
                     '<tbody>';

                  $.each(items, function (i, item) {
                     html += '<tr>' +
                        '<td>' + item.product_name + '</td>' +
                        '<td class="text-right">' + item.quantity + '</td>' +
                        '<td class="text-right">Rp ' + Number(item.unit_price).toLocaleString('id-ID') + '</td>' +
                        '<td class="text-right">Rp ' + Number(item.discount || 0).toLocaleString('id-ID') + '</td>' +
                        '<td class="text-right">Rp ' + Number(item.subtotal).toLocaleString('id-ID') + '</td>' +
                        '</tr>';
                  });

                  html += '</tbody>' +
                     '</table>' +
                     '</div>';

                  $('#detail_content').html(html);
               } else {
                  $('#detail_content').html('<div class="alert alert-danger">Gagal memuat data: ' + response.message + '</div>');
               }
            },
            error: function () {
               $('#detail_content').html('<div class="alert alert-danger">Terjadi kesalahan pada server.</div>');
            }
         });
      });

      $('#btnPrintModal').on('click', function () {
         if (currentOrderId) {
            window.open('{{ url("transaction/print/") }}' + currentOrderId, '_blank');
         }
      });

      $('#dataRiwayat').on('click', '.btn-void', function () {
         const id = $(this).data('id');
         const no = $(this).data('no');
         Swal.fire({
            title: 'Konfirmasi VOID',
            text: 'Apakah Anda yakin ingin membatalkan transaksi ' + no + '? Stok akan dikembalikan ke inventori.',
            icon: 'warning',
            showCancelButton: true,
            // confirmButtonColor: '#d33',
            // cancelButtonColor: '#3085d6',
            confirmButtonText: 'Ya, Batalkan!',
            cancelButtonText: 'Tidak',
            // reverseButtons: true,
            customClass: {
               confirmButton: 'btn btn-confirm btn-danger',
               cancelButton: 'btn btn-confirm btn-secondary'
            }
         }).then((result) => {
            if (result.isConfirmed) {
               window.location.href = '{{ url("transaction/void/") }}' + id;
            }
         });
      });

      $('#dataRiwayat').on('click', '.btn-refund', function () {
         const id = $(this).data('id');
         const no = $(this).data('no');
         Swal.fire({
            title: 'Konfirmasi Refund',
            text: 'Apakah Anda yakin ingin me-refund transaksi ' + no + '? Dana akan dikembalikan dan stok akan ditambahkan kembali.',
            icon: 'question',
            showCancelButton: true,
            // confirmButtonColor: '#f39c12',
            // cancelButtonColor: '#3085d6',
            confirmButtonText: 'Ya, Refund!',
            cancelButtonText: 'Batal',
            customClass: {
               confirmButton: 'btn btn-warning',
               cancelButton: 'btn btn-secondary'
            }
         }).then((result) => {
            if (result.isConfirmed) {
               window.location.href = '{{ url("transaction/refund/") }}' + id;
            }
         });
      });
   });
</script>