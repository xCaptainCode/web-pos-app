(function () {
   var cart = {};
   var activeCategory = 'all';

   var productGrid = document.getElementById('productGrid');
   var productSearch = document.getElementById('productSearch');
   var emptyProductState = document.getElementById('emptyProductState');
   var cartItems = document.getElementById('cartItems');
   var emptyCartState = document.getElementById('emptyCartState');
   var btnPay = document.getElementById('btnPay');

   var discountSelect = document.getElementById('discountSelect');
   var manualDiscountInput = document.getElementById('manualDiscount');
   var taxPercentInput = document.getElementById('taxPercent');
   var customerSelect = document.getElementById('customerSelect');

   function formatRupiah(number) {
      return 'Rp ' + Number(number || 0).toLocaleString('id-ID');
   }

   function clampNumber(value, minimum) {
      var parsed = Number(value);
      if (isNaN(parsed)) {
         return minimum;
      }
      return Math.max(minimum, parsed);
   }

   function escapeHtml(text) {
      return String(text || '')
         .replace(/&/g, '&amp;')
         .replace(/</g, '&lt;')
         .replace(/>/g, '&gt;')
         .replace(/\"/g, '&quot;')
         .replace(/'/g, '&#039;');
   }

   function getSelectedPromoDiscount(subtotal) {
      var selectedOption = discountSelect.options[discountSelect.selectedIndex];
      if (!selectedOption || !selectedOption.value) {
         return 0;
      }

      var type = selectedOption.getAttribute('data-type');
      var value = Number(selectedOption.getAttribute('data-value')) || 0;

      if (type === 'percentage') {
         return (subtotal * value) / 100;
      }

      if (type === 'fixed_amount') {
         return value;
      }

      return 0;
   }

   function calculateSummary() {
      var subtotal = 0;

      Object.keys(cart).forEach(function (id) {
         var item = cart[id];
         subtotal += item.price * item.qty;
      });

      var manualDiscount = clampNumber(manualDiscountInput.value, 0);
      var promoDiscount = getSelectedPromoDiscount(subtotal);
      var discount = Math.min(subtotal, manualDiscount + promoDiscount);
      var taxable = Math.max(0, subtotal - discount);
      var taxPercent = clampNumber(taxPercentInput.value, 0);
      var tax = taxable * (taxPercent / 100);
      var total = taxable + tax;

      return {
         subtotal: subtotal,
         discount: discount,
         tax: tax,
         total: total
      };
   }

   function renderSummary() {
      var summary = calculateSummary();

      document.getElementById('sumSubtotal').textContent = formatRupiah(summary.subtotal);
      document.getElementById('sumDiscount').textContent = formatRupiah(summary.discount);
      document.getElementById('sumTax').textContent = formatRupiah(summary.tax);
      document.getElementById('sumTotal').textContent = formatRupiah(summary.total);

      btnPay.disabled = Object.keys(cart).length === 0;
      return summary;
   }

   function updateChangeDisplay() {
      var summary = calculateSummary();
      var amountPaid = clampNumber(document.getElementById('amountPaid').value, 0);
      var change = amountPaid - summary.total;
      document.getElementById('changeAmount').textContent = formatRupiah(change > 0 ? change : 0);
   }

   function renderCart() {
      var keys = Object.keys(cart);
      cartItems.innerHTML = '';

      if (keys.length === 0) {
         emptyCartState.classList.remove('d-none');
         renderSummary();
         return;
      }

      emptyCartState.classList.add('d-none');

      keys.forEach(function (id) {
         var item = cart[id];
         var lineSubtotal = item.price * item.qty;

         var html = '' +
            '<div class="cart-item" data-id="' + item.id + '">' +
            '  <div class="d-flex justify-content-between align-items-start">' +
            '    <div>' +
            '      <div class="font-weight-bold">' + escapeHtml(item.name) + '</div>' +
            '      <small class="text-muted">' + formatRupiah(item.price) + ' / item</small>' +
            '    </div>' +
            '    <button type="button" class="btn btn btn-link text-danger btn-remove-item"><i class="fa-solid fa-trash-alt"></i></button>' +
            '  </div>' +
            '  <div class="d-flex justify-content-between align-items-center mt-2">' +
            '    <div class="qty-group">' +
            '      <button type="button" class="btn-qty-minus">-</button>' +
            '      <input type="text" value="' + item.qty + '" readonly>' +
            '      <button type="button" class="btn-qty-plus">+</button>' +
            '    </div>' +
            '    <div class="text-right">' +
            '      <small class="text-muted d-block">Stok: ' + item.stock + '</small>' +
            '      <strong>' + formatRupiah(lineSubtotal) + '</strong>' +
            '    </div>' +
            '  </div>' +
            '</div>';

         cartItems.insertAdjacentHTML('beforeend', html);
      });

      renderSummary();
   }

   function addToCart(product) {
      if (!product || product.active !== '1') {
         return;
      }

      var existing = cart[product.id];
      if (existing) {
         if (existing.qty >= existing.stock) {
            Toast.fire({ icon: 'warning', title: 'Jumlah melebihi stok.' });
            return;
         }
         existing.qty += 1;
      } else {
         if (product.stock <= 0) {
            return;
         }
         cart[product.id] = {
            id: product.id,
            name: product.name,
            price: Number(product.price),
            stock: Number(product.stock),
            qty: 1
         };
      }

      renderCart();
   }

   function filterProducts() {
      var keyword = productSearch.value.trim().toLowerCase();
      var cols = productGrid.querySelectorAll('.product-col');
      var visibleCount = 0;

      cols.forEach(function (col) {
         var productName = col.getAttribute('data-product-name') || '';
         var categoryId = col.getAttribute('data-category-id');

         var categoryMatch = (activeCategory === 'all' || categoryId === activeCategory);
         var keywordMatch = productName.indexOf(keyword) !== -1;

         if (categoryMatch && keywordMatch) {
            col.classList.remove('d-none');
            visibleCount += 1;
         } else {
            col.classList.add('d-none');
         }
      });

      if (visibleCount === 0) {
         emptyProductState.classList.remove('d-none');
      } else {
         emptyProductState.classList.add('d-none');
      }
   }

   function resetOrder(confirmMessage) {
      if (Object.keys(cart).length === 0) {
         return;
      }

      Swal.fire({
         icon: 'question',
         title: confirmMessage,
         showCancelButton: true,
         confirmButtonText: 'Ya',
         cancelButtonText: 'Tidak',
         reverseButtons: true,
         customClass: {
            confirmButton: 'btn btn-confirm btn-success',
            cancelButton: 'btn btn-confirm btn-secondary'
         }
      }).then(function (result) {
         if (!result.isConfirmed) {
            return;
         }

         cart = {};
         manualDiscountInput.value = 0;
         discountSelect.value = '';
         taxPercentInput.value = `{{ defaultTaxPercent }}`;
         document.getElementById('amountPaid').value = '';
         renderCart();
      });
   }

   document.querySelectorAll('.category-tab').forEach(function (tab) {
      tab.addEventListener('click', function () {
         document.querySelectorAll('.category-tab').forEach(function (item) {
            item.classList.remove('active');
         });

         tab.classList.add('active');
         activeCategory = tab.getAttribute('data-category');
         filterProducts();
      });
   });

   productSearch.addEventListener('input', filterProducts);

   productGrid.addEventListener('click', function (event) {
      var button = event.target.closest('.product-card');
      if (!button) {
         return;
      }

      addToCart({
         id: button.getAttribute('data-id'),
         name: button.getAttribute('data-name'),
         price: button.getAttribute('data-price'),
         stock: Number(button.getAttribute('data-stock')),
         active: button.getAttribute('data-active')
      });
   });

   cartItems.addEventListener('click', function (event) {
      var container = event.target.closest('.cart-item');
      if (!container) {
         return;
      }

      var id = container.getAttribute('data-id');
      if (!id || !cart[id]) {
         return;
      }

      if (event.target.closest('.btn-remove-item')) {
         delete cart[id];
         renderCart();
         return;
      }

      if (event.target.closest('.btn-qty-minus')) {
         cart[id].qty -= 1;
         if (cart[id].qty <= 0) {
            delete cart[id];
         }
         renderCart();
         return;
      }

      if (event.target.closest('.btn-qty-plus')) {
         if (cart[id].qty >= cart[id].stock) {
            Toast.fire({ icon: 'warning', title: 'Jumlah melebihi stok.' });
            return;
         }
         cart[id].qty += 1;
         renderCart();
      }
   });

   [discountSelect, manualDiscountInput, taxPercentInput].forEach(function (input) {
      input.addEventListener('change', renderSummary);
      input.addEventListener('keyup', renderSummary);
   });

   document.getElementById('btnNewOrder').addEventListener('click', function () {
      resetOrder('Reset order saat ini?');
   });

   document.getElementById('btnCancelOrder').addEventListener('click', function () {
      resetOrder('Batalkan transaksi dan kosongkan keranjang?');
   });

   document.getElementById('btnPay').addEventListener('click', function () {
      var summary = calculateSummary();
      if (Object.keys(cart).length === 0) {
         Toast.fire({ icon: 'warning', title: 'Keranjang masih kosong.' });
         return;
      }

      document.getElementById('modalTotal').textContent = formatRupiah(summary.total);
      document.getElementById('amountPaid').value = Math.ceil(summary.total);
      updateChangeDisplay();

      $('#paymentModal').modal('show');
   });

   document.getElementById('amountPaid').addEventListener('input', updateChangeDisplay);

   document.getElementById('checkoutForm').addEventListener('submit', function (event) {
      var summary = calculateSummary();
      var amountPaid = clampNumber(document.getElementById('amountPaid').value, 0);

      if (Object.keys(cart).length === 0) {
         event.preventDefault();
         Toast.fire({ icon: 'warning', title: 'Keranjang masih kosong.' });
         return;
      }

      if (amountPaid < summary.total) {
         event.preventDefault();
         Toast.fire({ icon: 'warning', title: 'Jumlah bayar belum cukup.' });
         return;
      }

      var compactCart = Object.keys(cart).map(function (id) {
         return {
            id: cart[id].id,
            qty: cart[id].qty
         };
      });

      document.getElementById('inputCartJson').value = JSON.stringify(compactCart);
      document.getElementById('inputManualDiscount').value = clampNumber(manualDiscountInput.value, 0);
      document.getElementById('inputTaxPercent').value = clampNumber(taxPercentInput.value, 0);
      document.getElementById('inputDiscountId').value = discountSelect.value;
      document.getElementById('inputCustomerId').value = customerSelect.value;
      document.getElementById('inputPaymentMethod').value = document.getElementById('paymentMethod').value;
      document.getElementById('inputAmountPaid').value = amountPaid;

      document.getElementById('btnProcessTransaction').disabled = true;
   });

   filterProducts();
   renderCart();
})();

document.addEventListener('keydown', function(e) {
   // Deteksi tombol F2
   if (e.key === 'F8') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const input = document.getElementById('paymentMethod');
      if (input) {
         input.focus();
         input.select(); // opsional: langsung select isi input
      }
   }
   if (e.key === 'F9') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const input = document.getElementById('amountPaid');
      if (input) {
         input.focus();
         input.select(); // opsional: langsung select isi input
      }
   }
   if (e.key === 'F2') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const input = document.getElementById('productSearch');
      if (input) {
         input.focus();
         input.select(); // opsional: langsung select isi input
      }
   }
   if (e.key === 'F3') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const input = document.getElementById('customerSelect');
      if (input) {
         input.focus();
         // input.select(); // opsional: langsung select isi input
      }
   }
   // if (e.key === 'F4') {
   //    e.preventDefault(); // mencegah fungsi default browser
      
   //    const select = document.getElementById('');
   //    if (select) {
   //       select.focus();
   //       // select.select(); // opsional: langsung select isi input
   //    }
   // }
   // if (e.key === 'F5') {
   //    e.preventDefault(); // mencegah fungsi default browser
      
   //    const select = document.getElementById('');
   //    if (select) {
   //       select.focus();
   //       // select.select(); // opsional: langsung select isi input
   //    }
   // }
   if (e.key === 'F6') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const input = document.getElementById('discountSelect');
      if (input) {
         input.focus();
         input.select(); // opsional: langsung select isi input
      }
   }
   if (e.key === 'F7') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const input = document.getElementById('manualDiscount');
      if (input) {
         input.focus();
         input.select(); // opsional: langsung select isi input
      }
   }
   if (e.key === 'F10') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const button = document.getElementById('btnNewOrder');
      if (button) {
         button.click();
      }
   }
   if (e.key === 'F11') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const button = document.getElementById('btnCancelOrder');
      if (button) {
         button.click();
      }
   }
   if (e.key === 'F12') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const button = document.getElementById('btnPay');
      if (button) {
         button.click();
      }
   }
   if (e.key === 'Enter') {
      e.preventDefault(); // mencegah fungsi default browser
      
      const button = document.getElementById('btnProcessTransaction');
      if (button) {
         button.click();
      }
   }
});