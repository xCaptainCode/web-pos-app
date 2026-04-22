<div class="content-header">
   <div class="container">
      <div class="row mb-2">
         <div class="col-sm-6">
            <h1 class="m-0">{{ title }}</h1>
         </div>
         <div class="col-sm-6 small">
            <ol class="breadcrumb float-sm-right">
               <li class="breadcrumb-item"><a href="{{ url('customer') }}">Customer</a></li>
               <li class="breadcrumb-item active">History</li>
            </ol>
         </div>
      </div>
   </div>
</div>

<div class="content">
   <div class="container">
      <!-- Customer Info Card -->
      <div class="row">
         <div class="col-md-12">
            <div class="card card-outline card-info">
               <div class="card-header">
                  <h3 class="card-title">Informasi Customer</h3>
               </div>
               <div class="card-body">
                  <div class="row">
                     <div class="col-md-6">
                        <table class="table table-borderless table-sm">
                           <tr>
                              <th width="150">Nama</th>
                              <td>: {{ customer.name }}</td>
                           </tr>
                           <tr>
                              <th>Telepon</th>
                              <td>: {{ customer.phone }}</td>
                           </tr>
                        </table>
                     </div>
                     <div class="col-md-6">
                        <table class="table table-borderless table-sm">
                           <tr>
                              <th width="150">Loyality Points</th>
                              <td>: <span class="badge badge-success">{{ customer.loyality_points }}</span></td>
                           </tr>
                           <tr>
                              <th>Total Spent</th>
                              <td>: <span class="text-bold">Rp {{ Helpers.number(customer.total_spent) }}</span></td>
                           </tr>
                        </table>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>

      <!-- Transaction History Card -->
      <div class="row">
         <div class="col-md-12">
            <div class="card card-outline card-primary">
               <div class="card-header">
                  <h3 class="card-title">Riwayat Transaksi</h3>
               </div>
               <div class="card-body">
                  <table id="tableHistory" class="table table-sm table-striped table-hover">
                     <thead>
                        <tr>
                           <th class="text-left">No</th>
                           <th class="text-left">Order No</th>
                           <th class="text-left">Cashier</th>
                           <th class="text-right">Total</th>
                           <th class="text-center">Status</th>
                           <th class="text-left">Waktu</th>
                        </tr>
                     </thead>
                     <tbody>
                        {% set total = 0 %}
                        {% for tr in transactions %}
                        <tr class="clickable-row" data-id="{{ tr.id }}" style="cursor: pointer;">
                           <td class="text-left">{{ loop.index }}</td>
                           <td class="text-left">{{ tr.order_no }}</td>
                           <td class="text-left">{{ tr.cashier_name }}</td>
                           <td class="text-right">Rp {{ Helpers.number(tr.total) }}</td>
                           <td class="text-center">
                              {% if tr.status == 'paid' %}
                                 <span class="badge badge-success">{{ tr.status|upper }}</span>
                              {% elseif tr.status == 'pending' %}
                                 <span class="badge badge-warning">{{ tr.status|upper }}</span>
                              {% else %}
                                 <span class="badge badge-danger">{{ tr.status|upper }}</span>
                              {% endif %}
                           </td>
                           <td class="text-left">{{ Helpers.formatDateTime(tr.created_at, 'l, d F Y H:i') }}</td>
                        </tr>
                        {% set total += tr.total %}
                        {% endfor %}
                     </tbody>
                     <tfoot class="text-right">
                        <tr>
                           <th colspan="3">Total</th>
                           <th>Rp {{ Helpers.number(total) }}</th>
                           <th></th>
                           <th></th>
                        </tr>
                     </tfoot>
                  </table>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>

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
   $(function () {
      $('#tableHistory').DataTable({
         "paging": true,
         "lengthChange": false,
         "searching": true,
         "ordering": true,
         "info": true,
         "autoWidth": false,
         "responsive": true,
         "order": [[1, "desc"]]
      });

      $('.clickable-row').on('click', function() {
         var orderId = $(this).data('id');
         var orderNo = $(this).find('td:eq(1)').text();
         
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
                  
                  var html = '<div class="row mb-3">' +
                              '  <div class="col-sm-6">' +
                              '     <strong>Kasir:</strong> ' + order.cashier_name + '<br>' +
                              '     <strong>Waktu:</strong> ' + order.created_at +
                              '  </div>' +
                              '  <div class="col-sm-6 text-right">' +
                              '     <strong>Status:</strong> <span class="badge ' + statusClass + '">' + order.status.toUpperCase() + '</span>' +
                              '  </div>' +
                             '</div>';
                  
                  html += '<table class="table table-sm table-bordered">' +
                             '<thead>' +
                                '<tr>' +
                                   '<th>Produk</th>' +
                                   '<th class="text-center">Qty</th>' +
                                   '<th class="text-right">Harga</th>' +
                                   '<th class="text-right">Total</th>' +
                                '</tr>' +
                             '</thead>' +
                             '<tbody>';
                  
                  $.each(items, function(i, item) {
                     html += '<tr>' +
                                '<td>' + item.product_name + '</td>' +
                                '<td class="text-center">' + item.quantity + '</td>' +
                                '<td class="text-right">Rp ' + Number(item.unit_price).toLocaleString() + '</td>' +
                                '<td class="text-right">Rp ' + Number(item.subtotal).toLocaleString() + '</td>' +
                             '</tr>';
                  });
                  
                  html += '</tbody>' +
                          '<tfoot>' +
                             '<tr>' +
                                '<th colspan="3" class="text-right">Subtotal</th>' +
                                '<th class="text-right ">Rp ' + Number(order.subtotal).toLocaleString() + '</th>' +
                             '</tr>' +
                             '<tr>' +
                                '<th colspan="3" class="text-right">Diskon</th>' +
                                '<th class="text-right ">Rp ' + Number(order.discount).toLocaleString() + '</th>' +
                             '</tr>' +
                             '<tr>' +
                                '<th colspan="3" class="text-right">Pajak</th>' +
                                '<th class="text-right ">Rp ' + Number(order.tax).toLocaleString() + '</th>' +
                             '</tr>' +
                             '<tr>' +
                                '<th colspan="3" class="text-right">Total</th>' +
                                '<th class="text-right text-primary">Rp ' + Number(order.total).toLocaleString() + '</th>' +
                             '</tr>' +
                          '</tfoot>' +
                          '</table>';
                  
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
   });
</script>
