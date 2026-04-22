<div class="card card-outline card-primary">
   <div class="card-header">
      <h3 class="card-title">Daftar Produk</h3>
      <div class="card-tools">
         {% if lowStockProducts %}
         <span class="badge badge-danger badge-pill">{{ lowStockProducts }}</span> <span class="small">Produk dengan stok rendah  </span>
         {% endif %}
      </div>
   </div>
   <div class="card-body">
      <div class="table-responsive">
         <table id="productTable" class="table table-sm table-bordered table-hover table-striped">
            <thead class="text-center">
               <tr>
                  <th style="width: 40px;">No</th>
                  <th>Nama Produk</th>
                  <th>Kategori</th>
                  <th>Stok</th>
                  <th>Harga</th>
                  <th>Status</th>
                  <th style="width: 80px;">Aksi</th>
               </tr>
            </thead>
            <tbody>
               {% for product in products %}
               <tr class="{% if product.stock <= 5 %}table-danger{% endif %}">
                  <td class="text-center">{{ loop.index }}</td>
                  <td class="text-left">{{ product.name }}</td>
                  <td class="text-center">{{ product.category_name|default('-') }}</td>
                  <td class="text-center">{{ product.stock }}</td>
                  <td class="text-right">Rp {{ Helpers.number(product.price) }}</td>
                  <td class="text-center">
                     {% if product.is_active %}
                     <span class="badge badge-success">Aktif</span>
                     {% else %}
                     <span class="badge badge-danger">Tidak Aktif</span>
                     {% endif %}
                  </td>
                  <td class="text-center">
                     <button type="button" class="btn btn-xs btn-warning btn-edit-product" data-toggle="modal"
                        data-target="#modalEditProduct" data-id="{{ product.id }}" data-name="{{ product.name }}"
                        data-description="{{ product.description }}" data-stock="{{ product.stock }}"
                        data-price="{{ product.price }}" data-category_id="{{ product.category_id }}"
                        data-is_active="{{ product.is_active ? '1' : '0' }}">
                        <i class="fas fa-edit"></i> Edit
                     </button>
                  </td>
               </tr>
               {% endfor %}
            </tbody>
         </table>
      </div>
   </div>
</div>

<script>
   $('#productTable').DataTable({
      responsive: true,
      autoWidth: false,
      pageLength: 10,
      lengthChange: true,
      language: {
         search: 'Cari:',
         paginate: {
            previous: '<i class="fas fa-angle-left"></i>',
            next: '<i class="fas fa-angle-right"></i>'
         }
      }
   });
</script>