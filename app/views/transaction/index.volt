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
         <div class="card-header">
            <h6 class="card-title text-muted small">
               <i class="fa-solid fa-filter mr-1"></i> Filter Transaksi
            </h6>
         </div>
         <div class="card-body">
            <form method="GET" action="{{ url('transaction/index') }}" class="row align-items-end">
               <div class="col-md-3 mb-2 mb-md-0">
                  <label class="small font-weight-bold text-uppercase text-muted">Dari Tanggal</label>
                  <input type="date" name="date_from" class="form-control form-control-sm" value="{{ filters.date_from }}">
               </div>
               <div class="col-md-3 mb-2 mb-md-0">
                  <label class="small font-weight-bold text-uppercase text-muted">Sampai Tanggal</label>
                  <input type="date" name="date_to" class="form-control form-control-sm" value="{{ filters.date_to }}">
               </div>
               <div class="col-md-2 mb-2 mb-md-0">
                  <label class="small font-weight-bold text-uppercase text-muted">Status</label>
                  <select name="status" class="form-control form-control-sm">
                     <option value="">Semua Status</option>
                     <option value="paid" {{ filters.status=='paid' ? 'selected' : '' }}>Paid</option>
                     <option value="pending" {{ filters.status=='pending' ? 'selected' : '' }}>Pending</option>
                     <option value="cancelled" {{ filters.status=='cancelled' ? 'selected' : '' }}>Cancelled</option>
                     <option value="refunded" {{ filters.status=='refunded' ? 'selected' : '' }}>Refunded</option>
                  </select>
               </div>
               <div class="col-md-2 mb-2 mb-md-0">
                  <label class="small font-weight-bold text-uppercase text-muted">Kasir</label>
                  <select name="user_id" class="form-control form-control-sm select2">
                     <option value="">Semua Kasir</option>
                     {% for cashier in cashiers %}
                     <option value="{{ cashier.id }}" {{ filters.user_id==cashier.id ? 'selected' : '' }}>{{
                        cashier.name }}</option>
                     {% endfor %}
                  </select>
               </div>
               <div class="col-md-2 text-right">
                  <button type="submit" class="btn btn-sm btn-primary btn-block">
                     <i class="fa-solid fa-magnifying-glass mr-1"></i> Cari
                  </button>
               </div>
            </form>
         </div>
      </div>
      <!-- Transactions Table -->
      <div class="card shadow-sm border-0">
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
                        <td class="align-middle text-right font-weight-bold text-primary">Rp {{
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
                              <button type="button" class="btn btn-sm btn-info btn-detail" data-id="{{ order.id }}" data-order-no="{{ order.order_no }}"
                                 title="Detail">
                                 <i class="fa-solid fa-info-circle"></i>
                              </button>
                              {# <a href="{{ url('transaction/print/' ~ order.id) }}" target="_blank"
                                 class="btn btn-sm btn-default border" title="Cetak Struk">
                                 <i class="fa-solid fa-print"></i>
                              </a> #}
                              {% if order.status == 'paid' %}
                              <button type="button" class="btn btn-sm btn-warning btn-refund"
                                 data-id="{{ order.id }}" data-no="{{ order.order_no }}" title="Refund">
                                 <i class="fa-solid fa-rotate-left"></i>
                              </button>
                              <button type="button" class="btn btn-sm btn-danger btn-void"
                                 data-id="{{ order.id }}" data-no="{{ order.order_no }}" title="Void / Cancel">
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
               </table>
            </div>
         </div>
      </div>
   </div>
</section>

<!-- Detail Modal -->
{# <div class="modal fade" id="modalDetail" tabindex="-1" role="dialog" aria-hidden="true">
   <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
      <div class="modal-content shadow-lg border-0 rounded-lg">
         <div class="modal-header bg-dark text-white">
            <h5 class="modal-title font-weight-bold">
               <i class="fa-solid fa-receipt mr-2 text-info"></i>Order <span id="detailOrderNo"></span>
            </h5>
            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body p-0">
            <div class="p-4 bg-light border-bottom">
               <div class="row">
                  <div class="col-md-6 border-right">
                     <label class="small text-muted text-uppercase font-weight-bold mb-1">Informasi Transaksi</label>
                     <table class="table table-sm table-borderless mb-0">
                        <tr>
                           <th width="100" class="small text-muted">Kasir</th>
                           <td id="detailCashier" class="font-weight-bold">-</td>
                        </tr>
                        <tr>
                           <th class="small text-muted">Customer</th>
                           <td id="detailCustomer">-</td>
                        </tr>
                        <tr>
                           <th class="small text-muted">Waktu</th>
                           <td id="detailTime">-</td>
                        </tr>
                     </table>
                  </div>
                  <div class="col-md-6 pl-md-4">
                     <label class="small text-muted text-uppercase font-weight-bold mb-1">Ringkasan Pembayaran</label>
                     <table class="table table-sm table-borderless mb-0">
                        <tr>
                           <th width="100" class="small text-muted">Status</th>
                           <td><span id="detailStatus" class="badge"></span></td>
                        </tr>
                        <tr>
                           <th class="small text-muted font-weight-bold">Total Akhir</th>
                           <td>
                              <h3 class="mb-0 font-weight-bold text-primary" id="detailTotal"></h3>
                           </td>
                        </tr>
                     </table>
                  </div>
               </div>
            </div>
            <div class="table-responsive">
               <table class="table table-striped mb-0">
                  <thead class="bg-secondary text-white small text-uppercase">
                     <tr>
                        <th class="px-4">Produk</th>
                        <th class="text-right">Qty</th>
                        <th class="text-right">Harga</th>
                        <th class="text-right">Diskon</th>
                        <th class="text-right px-4">Subtotal</th>
                     </tr>
                  </thead>
                  <tbody id="detailItemsBody">
                     <!-- Items will be injected here -->
                  </tbody>
                  <tfoot class="bg-light font-weight-bold">
                     <tr>
                        <td colspan="4" class="text-right px-4">Total</td>
                        <td class="text-right px-4 text-primary" id="footerTotal"></td>
                     </tr>
                  </tfoot>
               </table>
            </div>
         </div>
         <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary px-4 shadow-sm" data-dismiss="modal">Tutup</button>
            <button type="button" class="btn btn-primary px-4 shadow-sm" id="btnPrintModal">
               <i class="fa-solid fa-print mr-1"></i> Cetak Struk
            </button>
         </div>
      </div>
   </div>
</div> #}
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

      $('#dataRiwayat').DataTable({
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
         }
      });
      
      // Initialize Select2 if available
      if ($.fn.select2) {
         $('.select2').select2({
            width: '100%'
         });
      }

      let currentOrderId = null;

      $('.btn-detail').on('click', function() {
         var orderId = $(this).data('id');
         var orderNo = $(this).data('order-no');
         
         $('#detail_order_no').text(orderNo);
         $('#modalOrderDetail').modal('show');
         $('#detail_content').html('<div class="text-center p-4"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Memuat data...</p></div>');
         
         $.ajax({
            url: '{{ url("order/getDetailJson/") }}' + orderId,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
               if(response.success) {
                  var order = response.order;
                  var items = response.items;

                  var statusClass = 'badge-secondary';
                  if(order.status === 'paid') statusClass = 'badge-success';
                  if(order.status === 'pending') statusClass = 'badge-warning';
                  if(order.status === 'cancel') statusClass = 'badge-danger';
                  
                  var customerName = order.customer_name + (order.customer_phone ? ' (' + order.customer_phone + ')' : '');
                  var createdAt = new Date(order.created_at).toLocaleString('id-ID', { day: '2-digit', month: 'long', year: 'numeric', hour: '2-digit', minute: '2-digit' });

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
                  
                  $.each(items, function(i, item) {
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
            error: function() {
               $('#detail_content').html('<div class="alert alert-danger">Terjadi kesalahan pada server.</div>');
            }
         });
      });

      $('#btnPrintModal').on('click', function () {
         if (currentOrderId) {
            window.open('{{ url("transaction/print/") }}' + currentOrderId, '_blank');
         }
      });

      $('.btn-void').on('click', function () {
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

      $('.btn-refund').on('click', function () {
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