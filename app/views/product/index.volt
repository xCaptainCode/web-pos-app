<div class="content-header">
   <div class="container">
      <div class="row mb-2">
         <div class="col-sm-6">
            <h1 class="m-0">Product</h1>
         </div>
         <div class="col-sm-6 small">
            <ol class="breadcrumb float-sm-right">
               <li class="breadcrumb-item"><a href="#">Home</a></li>
               <li class="breadcrumb-item active">Product</li>
            </ol>
         </div>
      </div>
   </div>
</div>

<div class="content">
   <div class="container">
      <div class="form-group row align-items-center">
         <!-- FILTER (KIRI) -->
         <div class="col-12 col-md-3 col-lg-2 mb-2 mb-md-0">
            <select name="category" id="category" class="form-control form-control-sm" onchange="getData(this.value)">
               <option value="All" {{ selected_category == 'All' or selected_category is empty ? 'selected' : '' }}>Semua Kategori</option>
               {% for cat in categories %}
               <option value="{{ cat.id }}" {{ selected_category == cat.id ? 'selected' : '' }}>{{ cat.name }}</option>
               {% endfor %}
            </select>
         </div>

         <!-- BUTTON (KANAN) -->
         <div class="col-12 col-md-8 col-lg-10 text-md-right">
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#modalAddProduct">
               <i class="fas fa-plus"></i> Tambah Produk
            </button>
         </div>
      </div>
      <div class="row">
         <div id="loadData" class="col-lg-12">
            {% include "product/load.volt" %}
         </div>
      </div>
   </div>
</div>

<!-- Modal Tambah Produk -->
<div class="modal fade" id="modalAddProduct" tabindex="-1" role="dialog" aria-labelledby="modalAddProductLabel"
   aria-hidden="true">
   <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
      <div class="modal-content">
         <form action="{{ url('product/save') }}" method="post">
            <div class="modal-header bg-primary">
               <h5 class="modal-title" id="modalAddProductLabel">Tambah Produk Baru</h5>
               <button type="button" class="close" data-dismiss="modal" aria-label="Tutup">
                  <span aria-hidden="true">&times;</span>
               </button>
            </div>
            <div class="modal-body">
               <input type="hidden" name="ref_category_id" value="{{ selected_category }}">
               <div class="form-row">
                  <div class="form-group col-md-6">
                     <label for="addCategoryId">Kategori</label>
                     <select id="addCategoryId" name="category_id" class="form-control form-control-sm" required>
                        <option value="">Pilih Kategori</option>
                        {% for category in categories %}
                        <option value="{{ category.id }}">{{ category.name }}</option>
                        {% endfor %}
                     </select>
                  </div>
                  <div class="form-group col-md-6">
                     <label for="addName">Nama Produk</label>
                     <input type="text" id="addName" name="name" class="form-control form-control-sm"
                        placeholder="Nama produk" required>
                  </div>
               </div>
               <div class="form-group">
                  <label for="addDescription">Deskripsi</label>
                  <textarea id="addDescription" name="description" class="form-control form-control-sm" rows="2"
                     placeholder="Deskripsi produk"></textarea>
               </div>
               <div class="form-row">
                  <div class="form-group col-md-4">
                     <label for="addStock">Stok</label>
                     <input type="number" id="addStock" name="stock" class="form-control form-control-sm" min="0"
                        value="0" required>
                  </div>
                  <div class="form-group col-md-4">
                     <label for="addPrice">Harga</label>
                     <input type="number" id="addPrice" name="price" class="form-control form-control-sm" min="0"
                        value="0" required>
                  </div>
                  <div class="form-group col-md-4">
                     <label>Status</label>
                     <select name="is_active" class="form-control form-control-sm">
                        <option value="1">Aktif</option>
                        <option value="0">Tidak Aktif</option>
                     </select>
                  </div>
               </div>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-sm btn-secondary" data-dismiss="modal">Batal</button>
               <button type="submit" class="btn btn-sm btn-success"><i class="fas fa-save "></i> Simpan Produk</button>
            </div>
         </form>
      </div>
   </div>
</div>

<!-- Modal Edit Produk -->
<div class="modal fade" id="modalEditProduct" tabindex="-1" role="dialog" aria-labelledby="modalEditProductLabel"
   aria-hidden="true">
   <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
      <div class="modal-content">
         <form action="{{ url('product/update') }}" method="post">
            <div class="modal-header bg-warning">
               <h5 class="modal-title" id="modalEditProductLabel">Edit Produk</h5>
               <button type="button" class="close" data-dismiss="modal" aria-label="Tutup">
                  <span aria-hidden="true">&times;</span>
               </button>
            </div>
            <div class="modal-body">
               <input type="hidden" name="id" id="editProductId">
               <input type="hidden" name="ref_category_id" value="{{ selected_category }}">
               <div class="form-row">
                  <div class="form-group col-md-6">
                     <label for="editCategoryId">Kategori</label>
                     <select id="editCategoryId" name="category_id" class="form-control form-control-sm" required>
                        <option value="">Pilih Kategori</option>
                        {% for category in categories %}
                        <option value="{{ category.id }}">{{ category.name }}</option>
                        {% endfor %}
                     </select>
                  </div>
                  <div class="form-group col-md-6">
                     <label for="editName">Nama Produk</label>
                     <input type="text" id="editName" name="name" class="form-control form-control-sm"
                        placeholder="Nama produk" required>
                  </div>
               </div>
               <div class="form-group">
                  <label for="editDescription">Deskripsi</label>
                  <textarea id="editDescription" name="description" class="form-control form-control-sm" rows="2"
                     placeholder="Deskripsi produk"></textarea>
               </div>
               <div class="form-row">
                  <div class="form-group col-md-4">
                     <label for="editStock">Stok</label>
                     <input type="number" id="editStock" name="stock" class="form-control form-control-sm" min="0"
                        value="0" required>
                  </div>
                  <div class="form-group col-md-4">
                     <label for="editPrice">Harga</label>
                     <input type="number" id="editPrice" name="price" class="form-control form-control-sm" min="0"
                        value="0" required>
                  </div>
                  <div class="form-group col-md-4">
                     <label>Status</label>
                     <select name="is_active" id="editIsActive" class="form-control form-control-sm">
                        <option value="1">Aktif</option>
                        <option value="0">Tidak Aktif</option>
                     </select>
                  </div>
               </div>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-sm btn-secondary" data-dismiss="modal">Batal</button>
               <button type="submit" class="btn btn-sm btn-primary"><i class="fas fa-save"></i> Perbarui Produk</button>
            </div>
         </form>
      </div>
   </div>
</div>

<script>
   $(function () {
      $(document).on('click', '.btn-edit-product', function () {
         var button = $(this);
         $('#editProductId').val(button.data('id'));
         $('#editCategoryId').val(button.data('category_id'));
         $('#editName').val(button.data('name'));
         $('#editDescription').val(button.data('description'));
         $('#editStock').val(button.data('stock'));
         $('#editPrice').val(button.data('price'));
         $('#editIsActive').val(button.data('is_active'));
      });
      
   });

   function getData(id){
      window.location.href = "{{ url('product') }}?category_id=" + id;
   }
</script>