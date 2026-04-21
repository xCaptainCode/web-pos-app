{{ stylesheet_link("css/cashier.css") }}

<div class="content pt-3 pb-3 cashier-screen">
   <div class="container-fluid h-100">
      <div class="row h-100">
         <div class="col-lg-9 h-100 pr-lg-2 mb-3 mb-lg-0">
            <div class="card card-outline card-primary bg-white h-100 mb-0">
               <div class="card-header pb-2">
                  <div class="d-flex flex-wrap justify-content-between align-items-center">
                     <h5 class="mb-2 mb-md-0"><i class="fa-solid fa-cash-register"></i> Cashier</h5>
                     <div class="input-group input-group-sm cashier-search-wrap">
                        <span class="input-group-text border-0 bg-white tool-tips" data-toggle="modal" data-target="#toolTips"><i class="fa-solid fa-lightbulb"></i></span>
                        <div class="input-group-prepend">
                           <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                        </div>
                        <input type="text" id="productSearch" class="form-control" placeholder="Cari produk... F2">
                     </div>
                  </div>
                  <ul class="nav nav-pills mt-3 flex-nowrap overflow-auto" id="categoryTabs">
                     <li class="nav-item">
                        <button type="button"
                           class="btn btn-sm btn-rounded mr-1 btn-outline-primary active category-tab"
                           data-category="all">Semua</button>
                     </li>
                     {% for category in categories %}
                     <li class="nav-item">
                        <button type="button" class="btn btn-sm btn-rounded mr-1 btn-outline-primary category-tab"
                           data-category="{{ category.id }}">{{ Helpers.ucwords(category.name) }}</button>
                     </li>
                     {% endfor %}
                  </ul>
               </div>
               <div class="card-body product-grid-wrap">
                  <div class="row" id="productGrid">
                     {% for product in products %}
                     {% set inactive = (product.is_active == false) or (product.stock <= 0) %} 
                     <div class="col-sm-6 col-md-4 col-xl-3 mb-3 product-col" 
                        data-product-name="{{ product.name|lower }}"
                        data-category-id="{{ product.category_id }}"
                        data-is-active="{{ product.is_active ? '1' : '0' }}" data-stock="{{ product.stock }}">
                        <button type="button"
                           class="card text-left w-100 h-100 product-card {{ inactive ? 'product-disabled' : '' }}" {{
                           inactive ? 'disabled' : '' }} data-id="{{ product.id }}" data-name="{{ product.name }}"
                           data-price="{{ product.price }}" data-stock="{{ product.stock }}"
                           data-active="{{ product.is_active ? '1' : '0' }}">
                           <div class="card-body p-3">
                              <div class="d-flex justify-content-between align-items-start mb-2">
                                 <span class="badge badge-light border">{{ product.category_name ? product.category_name
                                    : 'Tanpa Kategori' }}</span>
                                 {% if inactive %}
                                 <span class="badge badge-secondary">Unavailable</span>
                                 {% else %}
                                 <span class="badge badge-success">Ready</span>
                                 {% endif %}
                              </div>
                              <h6 class="font-weight-bold mb-1 text-truncate">{{ product.name }}</h6>
                              <small class="text-muted d-block mb-2">{{ product.description ? product.description : '-'
                                 }}</small>
                              <div class="d-flex justify-content-between align-items-center">
                                 <strong>Rp {{ Helpers.number(product.price) }}</strong>
                                 <small class="text-muted">Stok: {{ product.stock }}</small>
                              </div>
                           </div>
                        </button>
                  </div>
                  {% endfor %}
               </div>
               <div class="alert alert-light border text-center mb-0 d-none" id="emptyProductState">
                  Produk tidak ditemukan.
               </div>
            </div>
         </div>
      </div>

      <div class="col-lg-3 h-100 pl-lg-2">
         <div class="card card-outline card-success h-100 mb-0">
            <div class="card-header pb-2">
               <div class="d-flex justify-content-between align-items-center mb-2">
                  <h5 class="mb-0"><i class="fa-solid fa-basket-shopping"></i> Cart</h5>
                  <div>
                     <button type="button" id="btnNewOrder" class="btn btn-sm btn-outline-primary mr-1">New
                        Order</button>
                     <button type="button" id="btnCancelOrder" class="btn btn-sm btn-outline-danger">Batal</button>
                  </div>
               </div>
               <label class="small mb-1">Member</label>
               <select id="customerSelect" class="form-control form-control-sm">
                  <option value="">Walk-in Customer</option>
                  {% for customer in customers %}
                  <option value="{{ customer.id }}">{{ customer.name }}{{ customer.phone ? ' - ' ~ customer.phone : '' }}</option>
                  {% endfor %}
               </select>
            </div>
            <div class="card-body d-flex flex-column p-0">
               <div class="cart-items-wrap px-3 pt-3" id="cartItemsWrap">
                  <div class="text-center text-muted py-5" id="emptyCartState">Keranjang masih kosong.</div>
                  <div id="cartItems"></div>
               </div>

               <div class="cart-summary border-top px-3 py-3 mt-auto">
                  <div class="d-flex justify-content-between mb-1">
                     <span>Subtotal</span>
                     <strong id="sumSubtotal">Rp 0</strong>
                  </div>

                  <div class="form-group mb-2">
                     <label class="small mb-1">Promo Diskon</label>
                     <select id="discountSelect" class="form-control form-control-sm">
                        <option value="">Tanpa Promo</option>
                        {% for discount in discounts %}
                        <option value="{{ discount.id }}" data-type="{{ discount.type }}"
                           data-value="{{ discount.value }}">
                           {{ discount.name }}
                           {% if discount.type == 'percentage' %}
                           ({{ discount.value }}%)
                           {% else %}
                           (Rp {{ discount.value }})
                           {% endif %}
                        </option>
                        {% endfor %}
                     </select>
                  </div>

                  <div class="form-row mb-2">
                     <div class="form-group col-6 mb-0">
                        <label class="small mb-1">Diskon Manual</label>
                        <input type="number" min="0" step="1" id="manualDiscount" class="form-control form-control-sm"
                           value="0">
                     </div>
                     <div class="form-group col-6 mb-0">
                        <label class="small mb-1">Tax (%)</label>
                        <input type="number" min="0" step="0.01" id="taxPercent" class="form-control form-control-sm"
                           value="{{ defaultTaxPercent }}">
                     </div>
                  </div>

                  <div class="d-flex justify-content-between mb-1">
                     <span>Total Diskon</span>
                     <strong id="sumDiscount">Rp 0</strong>
                  </div>
                  <div class="d-flex justify-content-between mb-2">
                     <span>Pajak</span>
                     <strong id="sumTax">Rp 0</strong>
                  </div>
                  <div class="d-flex justify-content-between align-items-center border-top pt-2">
                     <span class="h5 mb-0">Total</span>
                     <span class="h4 mb-0 font-weight-bold text-success" id="sumTotal">Rp 0</span>
                  </div>

                  <button type="button" class="btn btn-success btn-block mt-3" id="btnPay" disabled>
                     <i class="fa-solid fa-money-bill-wave"></i> Bayar
                  </button>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>
</div>

<div id="toolTips" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="tool-tips-title" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
         <div class="modal-header">
            <h5 class="modal-title" id="tool-tips-title"><i class="fas fa-lightbulb"></i> Tooltip</h5>
            <button class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <h5 class="text-center text-bold">Shortcut tombol fungsi</h5>
            <dl class="row">
               <dt class="col-2">F2</dt>
               <dd class="col-10">Cari produk</dd>
               <dt class="col-2">F3</dt>
               <dd class="col-10">Customer</dd>
               <dt class="col-2">F6</dt>
               <dd class="col-10">Promo Discount</dd>
               <dt class="col-2">F7</dt>
               <dd class="col-10">Discount Manual</dd>
               <dt class="col-2">F8</dt>
               <dd class="col-10">Metode Pembayaran</dd>
               <dt class="col-2">F9</dt>
               <dd class="col-10">Jumlah Bayar</dd>
               <dt class="col-2">F10</dt>
               <dd class="col-10">New Order</dd>
               <dt class="col-2">F11</dt>
               <dd class="col-10">Batal</dd>
               <dt class="col-2">F12</dt>
               <dd class="col-10">Bayar</dd>
            </dl>
         </div>
         <div class="modal-footer">
            <button class="btn btn-md btn-default" data-dismiss="modal">Tutup</button>
         </div>
      </div>
   </div>
</div>

<div class="modal fade" id="paymentModal" tabindex="-1" role="dialog" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered" role="document">
      <form id="checkoutForm" action="{{ url('cashier/checkout') }}" method="post" class="modal-content">
         <div class="modal-header bg-success">
            <h5 class="modal-title">Pembayaran</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
               <span aria-hidden="true">&times;</span>
            </button>
         </div>
         <div class="modal-body">
            <div class="mb-3">
               <small class="text-muted">Total Bayar</small>
               <h2 class="font-weight-bold text-center text-success mb-0" id="modalTotal">Rp 0</h2>
            </div>

            <div class="form-group">
               <label>Metode Pembayaran</label>
               <select id="paymentMethod" class="form-control" required>
                  <option value="CASH">Cash</option>
                  <option value="TRANSFER">Transfer</option>
                  <option value="QRIS">QRIS</option>
                  <option value="EDC">EDC</option>
               </select>
            </div>

            <div class="form-group">
               <label>Jumlah Bayar</label>
               <input type="number" id="amountPaid" min="0" step="1" class="form-control text-center" required>
            </div>

            <div class="alert alert-info mb-0">
               Kembalian: <strong class="font-weight-bold float-right" id="changeAmount">Rp 0</strong>
            </div>

            <input type="hidden" name="cart_json" id="inputCartJson">
            <input type="hidden" name="manual_discount" id="inputManualDiscount">
            <input type="hidden" name="tax_percent" id="inputTaxPercent">
            <input type="hidden" name="discount_id" id="inputDiscountId">
            <input type="hidden" name="customer_id" id="inputCustomerId">
            <input type="hidden" name="payment_method" id="inputPaymentMethod">
            <input type="hidden" name="amount_paid" id="inputAmountPaid">
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Tutup</button>
            <button type="submit" class="btn btn-success" id="btnProcessTransaction">Proses Transaksi</button>
         </div>
      </form>
   </div>
</div>

{{ javascript_include("js/cashier.js") }}