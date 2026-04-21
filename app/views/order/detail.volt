<div class="content-header">
   <div class="container">
      <div class="row mb-2">
         <div class="col-sm-6">
            <h1 class="m-0">Detail Transaksi</h1>
         </div>
         <div class="col-sm-6 text-sm-right">
            <a href="{{ url('index') }}" class="btn btn-sm btn-outline-secondary mt-2 mt-sm-0">
               <i class="fa-solid fa-arrow-left"></i> Kembali ke Dashboard
            </a>
         </div>
      </div>
   </div>
</div>

<div class="content">
   <div class="container">
      <div class="card card-outline card-primary">
         <div class="card-header">
            <h3 class="card-title mb-0">Order {{ order.order_no }}</h3>
         </div>
         <div class="card-body">
            <div class="row">
               <div class="col-md-6">
                  <table class="table table-sm table-borderless mb-0">
                     <tr>
                        <th width="140">Kasir</th>
                        <td>{{ order.cashier_name }}</td>
                     </tr>
                     <tr>
                        <th>Customer</th>
                        <td>{{ order.customer_name }}{{ order.customer_phone ? ' (' ~ order.customer_phone ~ ')' : '' }}</td>
                     </tr>
                     <tr>
                        <th>Status</th>
                        <td>
                           <span class="badge {{ order.status == 'paid' ? 'badge-success' : 'badge-secondary' }}">
                              {{ order.status }}
                           </span>
                        </td>
                     </tr>
                     <tr>
                        <th>Waktu</th>
                        {# <td>{{ date('d-m-Y H:i:s', strtotime(order.created_at)) }}</td> #}
                        <td>{{ order.created_at }}</td>
                     </tr>
                  </table>
               </div>
               <div class="col-md-6">
                  <table class="table table-sm table-borderless mb-0">
                     <tr>
                        <th width="140">Subtotal</th>
                        <td>Rp {{ Helpers.number(order.subtotal) }}</td>
                     </tr>
                     <tr>
                        <th>Discount</th>
                        <td>Rp {{ Helpers.number(order.discount) }}</td>
                     </tr>
                     <tr>
                        <th>Tax</th>
                        <td>Rp {{ Helpers.number(order.tax) }}</td>
                     </tr>
                     <tr>
                        <th>Total</th>
                        <td><strong>Rp {{ Helpers.number(order.total) }}</strong></td>
                     </tr>
                  </table>
               </div>
            </div>
         </div>
      </div>

      <div class="card card-outline card-secondary">
         <div class="card-header">
            <h3 class="card-title mb-0">Item Order</h3>
         </div>
         <div class="card-body table-responsive p-0">
            <table class="table table-sm table-striped mb-0">
               <thead>
                  <tr>
                     <th>Produk</th>
                     <th class="text-right">Qty</th>
                     <th class="text-right">Harga Satuan</th>
                     <th class="text-right">Diskon</th>
                     <th class="text-right">Subtotal</th>
                  </tr>
               </thead>
               <tbody>
                  {% if items|length > 0 %}
                  {% for item in items %}
                  <tr>
                     <td>{{ item.product_name }}</td>
                     <td class="text-right">{{ item.quantity }}</td>
                     <td class="text-right">Rp {{ Helpers.number(item.unit_price) }}</td>
                     <td class="text-right">Rp {{ Helpers.number(item.discount) }}</td>
                     <td class="text-right">Rp {{ Helpers.number(item.subtotal) }}</td>
                  </tr>
                  {% endfor %}
                  {% else %}
                  <tr>
                     <td colspan="5" class="text-center text-muted">Item order tidak ditemukan.</td>
                  </tr>
                  {% endif %}
               </tbody>
            </table>
         </div>
      </div>
   </div>
</div>
