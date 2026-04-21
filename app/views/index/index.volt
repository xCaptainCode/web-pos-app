<style>
   .dashboard-link-row {
      cursor: pointer;
   }

   .dashboard-link-row:hover {
      background-color: #f8f9fa;
   }

   .dashboard-card-title {
      font-size: 0.9rem;
      margin-bottom: 0.35rem;
      color: #6c757d;
   }

   .dashboard-card-value {
      font-size: 1.5rem;
      font-weight: 700;
      margin-bottom: 0;
   }

   .dashboard-chart-wrap {
      height: 300px;
      position: relative;
   }
</style>

<div class="content-header">
   <div class="row mb-2">
      <div class="col-sm-6">
         <h1 class="m-0">Dashboard</h1>
         <small class="text-muted">Ringkasan bisnis POS - {{ periodLabel }}</small>
      </div>
      <div class="col-sm-6">
         <div class="btn-group btn-group-sm float-sm-right mt-2 mt-sm-0">
            <a href="{{ url('index?period=today') }}"
               class="btn {{ period == 'today' ? 'btn-primary' : 'btn-outline-primary' }}">Today</a>
            <a href="{{ url('index?period=week') }}"
               class="btn {{ period == 'week' ? 'btn-primary' : 'btn-outline-primary' }}">This Week</a>
            <a href="{{ url('index?period=month') }}"
               class="btn {{ period == 'month' ? 'btn-primary' : 'btn-outline-primary' }}">This Month</a>
         </div>
      </div>
   </div>
</div>

<div class="content">
   <div class="row">
      <div class="col-lg-3 col-md-6 col-12">
         <!-- small card -->
         <div class="small-box bg-success">
            <div class="inner">
               <h3>Rp {{ Helpers.number(totalRevenue) }}</h3>

               <p>Total Pendapatan</p>
            </div>
            <div class="icon">
               {# <i class="fas fa-shopping-cart"></i> #}
               <i class="fa-solid fa-money-bill-wave"></i>
            </div>
            <a href="#" class="small-box-footer" hidden>
               More info <i class="fas fa-arrow-circle-right"></i>
            </a>
         </div>
      </div>
      <!-- ./col -->
      <div class="col-lg-3 col-md-6 col-12">
         <!-- small card -->
         <div class="small-box bg-info">
            <div class="inner">
               <h3>{{ totalOrders }}</h3>

               <p>Total Order</p>
            </div>
            <div class="icon">
               <i class="fas fa-shopping-cart"></i>
            </div>
            <a href="#" class="small-box-footer" hidden>
               More info <i class="fas fa-arrow-circle-right"></i>
            </a>
         </div>
      </div>
      <!-- ./col -->
      <div class="col-lg-3 col-md-6 col-12">
         <!-- small card -->
         <div class="small-box bg-warning">
            <div class="inner">
               <h3>{{ totalCustomers }}</h3>

               <p>Jumlah Customer</p>
            </div>
            <div class="icon">
               <i class="fas fa-users"></i>
            </div>
            <a href="#" class="small-box-footer" hidden>
               More info <i class="fas fa-arrow-circle-right"></i>
            </a>
         </div>
      </div>
      <!-- ./col -->
      <div class="col-lg-3 col-md-6 col-12">
         <!-- small card -->
         <div class="small-box bg-danger">
            <div class="inner">
               <h3>Rp {{ Helpers.number(avgOrder) }}</h3>

               <p>Rata-rata Nilai Order</p>
            </div>
            <div class="icon">
               <i class="fas fa-chart-pie"></i>
            </div>
            <a href="#" class="small-box-footer" hidden>
               More info <i class="fas fa-arrow-circle-right"></i>
            </a>
         </div>
      </div>
      <!-- ./col -->
   </div>
   <div class="row">
      <div class="col-12">
         <div class="card card-outline card-primary">
            <div class="card-header">
               <h3 class="card-title mb-0">Grafik Pendapatan Harian</h3>
            </div>
            <div class="card-body">
               <div class="dashboard-chart-wrap">
                  <canvas id="revenueChart"></canvas>
               </div>
            </div>
         </div>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-5">
         <div class="card card-indigo">
            <div class="card-header">
               <h3 class="card-title mb-0">Transaksi Terbaru</h3>
            </div>
            <div class="card-body table-responsive p-0">
               <table class="table table-sm table-striped mb-0">
                  <thead>
                     <tr>
                        <th>Order No</th>
                        <th>Kasir</th>
                        <th>Customer</th>
                        <th class="text-right">Total</th>
                        <th>Status</th>
                        {# <th>Waktu</th> #}
                     </tr>
                  </thead>
                  <tbody>
                     {% if latestTransactions|length > 0 %}
                     {% for trx in latestTransactions %}
                     <tr class="dashboard-link-row" onclick="detailTransaction('{{ trx.id }}')">
                        <td>{{ trx.order_no }}</td>
                        <td>{{ trx.cashier_name }}</td>
                        <td>{{ trx.customer_name }}</td>
                        <td class="text-right">Rp {{ Helpers.number(trx.total) }}</td>
                        <td>
                           <span class="badge {{ trx.status == 'paid' ? 'badge-success' : 'badge-secondary' }}">
                              {{ trx.status }}
                           </span>
                        </td>
                        {# <td>{{ date('d-m-Y H:i', strtotime(trx.created_at)) }}</td> #}
                        {# <td>{{ trx.created_at }}</td> #}
                     </tr>
                     {% endfor %}
                     {% else %}
                     <tr>
                        <td colspan="6" class="text-center text-muted">Belum ada transaksi.</td>
                     </tr>
                     {% endif %}
                  </tbody>
               </table>
            </div>
         </div>
      </div>
      <div class="col-lg-4">
         <div class="card card-orange">
            <div class="card-header text-white">
               <h3 class="card-title mb-0">Produk Terlaris</h3>
            </div>
            <div class="card-body table-responsive p-0">
               <table class="table table-sm table-striped mb-0">
                  <thead>
                     <tr>
                        <th>Produk</th>
                        <th>Kategori</th>
                        <th class="text-right">Qty</th>
                        <th class="text-right">Pendapatan</th>
                     </tr>
                  </thead>
                  <tbody>
                     {% if topProducts|length > 0 %}
                     {% for item in topProducts %}
                     <tr>
                        <td>{{ item.name }}</td>
                        <td>{{ item.category_name }}</td>
                        <td class="text-right">{{ item.total_qty }}</td>
                        <td class="text-right">Rp {{ Helpers.number(item.total_revenue) }}</td>
                     </tr>
                     {% endfor %}
                     {% else %}
                     <tr>
                        <td colspan="4" class="text-center text-muted">Belum ada data penjualan untuk periode ini.</td>
                     </tr>
                     {% endif %}
                  </tbody>
               </table>
            </div>
         </div>
      </div>
      <div class="col-lg-3">
         <div class="card card-dark">
            <div class="card-header">
               <h3 class="card-title mb-0">Stok Hampir Habis (≤ {{ lowStockThreshold }})</h3>
            </div>
            <div class="card-body table-responsive p-0">
               <table class="table table-sm table-striped mb-0">
                  <thead>
                     <tr>
                        <th>Produk</th>
                        <th>Kategori</th>
                        <th class="text-right">Stok</th>
                     </tr>
                  </thead>
                  <tbody>
                     {% if lowStockProducts|length > 0 %}
                     {% for product in lowStockProducts %}
                     <tr class="dashboard-link-row" onclick="detailProduct()">
                        <td>{{ product.name }}</td>
                        <td>{{ product.category_name }}</td>
                        <td class="text-right">
                           <span class="badge {{ product.stock <= 1 ? 'badge-danger' : 'badge-warning' }}">
                              {{ product.stock }}
                           </span>
                        </td>
                     </tr>
                     {% endfor %}
                     {% else %}
                     <tr>
                        <td colspan="3" class="text-center text-muted">Semua stok masih aman.</td>
                     </tr>
                     {% endif %}
                  </tbody>
               </table>
            </div>
         </div>
      </div>
   </div>
</div>

<script>
   (function () {
      var endpoint = "{{ chartEndpoint }}";
      var canvas = document.getElementById('revenueChart');
      if (!canvas) {
         return;
      }

      fetch(endpoint)
         .then(function (response) {
            return response.json();
         })
         .then(function (payload) {
            if (payload.error) {
               return;
            }

            new Chart(canvas, {
               type: 'line',
               data: {
                  labels: payload.labels,
                  datasets: [{
                     label: 'Pendapatan',
                     data: payload.data,
                     borderColor: '#007bff',
                     backgroundColor: 'rgba(0, 123, 255, 0.2)',
                     borderWidth: 2,
                     fill: true,
                     tension: 0.3,
                     pointRadius: 3
                  }]
               },
               options: {
                  responsive: true,
                  maintainAspectRatio: false,
                  scales: {
                     yAxes: [{
                        ticks: {
                           beginAtZero: true,
                           callback: function (value) {
                              return 'Rp ' + Number(value).toLocaleString('id-ID');
                           }
                        }
                     }]
                  },
                  tooltips: {
                     callbacks: {
                        label: function (tooltipItem) {
                           return 'Rp ' + Number(tooltipItem.yLabel).toLocaleString('id-ID');
                        }
                     }
                  }
               }
            });
         })
         .catch(function () {
            // Ignore fetch chart errors on UI
         });
   })();
</script>

<script>
   function detailTransaction(id) {
      window.location="{{ url('order/detail/') }}" + id;
   }
   function detailProduct() {
      window.location = "{{ url('product') }}" ;
   }
</script>