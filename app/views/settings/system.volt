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
      <div class="row">
         <div class="col-md-8 offset-md-2">
            <div class="card card-outline card-primary">
               <div class="card-header">
                  <h3 class="card-title">Konfigurasi Aplikasi</h3>
               </div>
               <form action="{{ url('settings/systemSave') }}" method="post">
                  <div class="card-body">
                     <div class="form-group">
                        <label for="store_name">Nama Toko / Outlet</label>
                        <input type="text" name="config[store_name]" id="store_name" 
                           class="form-control" value="{{ config['store_name'] }}" required>
                        <small class="text-muted">Nama ini akan muncul di struk dan judul aplikasi.</small>
                     </div>
                     
                     <div class="form-group">
                        <label for="tax_percentage">Persentase Pajak (%)</label>
                        <div class="input-group">
                           <input type="number" name="config[tax_percentage]" id="tax_percentage" 
                              class="form-control" value="{{ config['tax_percentage'] }}" step="0.01" required>
                           <div class="input-group-append">
                              <span class="input-group-text">%</span>
                           </div>
                        </div>
                        <small class="text-muted">Pajak yang dikenakan pada setiap transaksi.</small>
                     </div>

                     <div class="form-group">
                        <label for="order_no_format">Format Nomor Pesanan</label>
                        <input type="text" name="config[order_no_format]" id="order_no_format" 
                           class="form-control" value="{{ config['order_no_format'] }}" required>
                        <small class="text-muted">
                           Gunakan placeholder: <br>
                           <code>{Ymd}</code> untuk tanggal (Ymd), <br>
                           <code>{03d}</code> untuk nomor urut (panjang 3 digit). <br>
                           Contoh: <code>TRX-{Ymd}-{03d}</code> menghasilkan <code>TRX-20240323-001</code>
                        </small>
                     </div>
                  </div>
                  <div class="card-footer text-right">
                     <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Simpan Perubahan
                     </button>
                  </div>
               </form>
            </div>
         </div>
      </div>
   </div>
</div>
