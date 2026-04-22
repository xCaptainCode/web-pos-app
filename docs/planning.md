# Planning: Halaman Transaksi POS

> Stack: PHP 7.3 · Phalcon 3.4.5 · PostgreSQL · AdminLTE / Bootstrap 4

---

## 1. Gambaran Halaman

Layout dua kolom penuh layar (full-height, no-scroll):

```
┌──────────────────────────────┬──────────────────────────────┐
│  PANEL KIRI — Product Browser│  PANEL KANAN — Order / Cart  │
│  (60% lebar)                 │  (40% lebar)                 │
└──────────────────────────────┴──────────────────────────────┘
```

- **Panel Kiri**: Filter kategori (tab/pill), grid produk, search bar
- **Panel Kanan**: Cart items, ringkasan harga, aksi bayar

---

## 2. Panel Kiri — Product Browser

### Komponen
- **Search bar** di atas — filter produk by name (client-side atau AJAX)
- **Tab kategori** — diambil dari tabel `categories`, diurutkan by `sort_order`
- **Grid produk** — card dengan nama, harga, stok. Klik → tambah ke cart
- Produk dengan `is_active = false` atau `stock = 0` ditampilkan disabled/greyed

### Behavior
- Klik produk → langsung masuk cart (quantity +1 jika sudah ada)
- Filter kategori mengganti grid produk (AJAX atau JS filter DOM)
- Stok ditampilkan, tapi validasi stok cukup saat checkout saja

---

## 3. Panel Kanan — Cart & Order

### Komponen

**Header Cart**
- Tombol **"New Order"** — reset cart
- Dropdown/search **Customer** (opsional, bisa skip / walk-in)

**List Cart Items**
- Nama produk, harga satuan
- Kontrol quantity (+ / −) dan tombol hapus
- Quantity tidak boleh melebihi stok produk
- Subtotal per item (unit_price × quantity)

**Ringkasan Harga**
- Subtotal
- Diskon (manual input nominal atau pilih dari tabel `discounts`)
- Tax (persentase, bisa hardcode atau dari config)
- **Total** (besar, bold)

**Aksi Bayar**
- Tombol **"Bayar"** → buka modal pembayaran
- Tombol **"Batal"** → reset cart dengan konfirmasi

---

## 4. Modal Pembayaran

Tampil saat tombol Bayar diklik.

### Isi Modal
- Tampilkan **Total** yang harus dibayar
- Input **Jumlah Bayar** (uang yang diterima kasir)
- Kalkulasi **Kembalian** otomatis (real-time saat input)
- Pilihan metode: Cash / Transfer / dll (bisa sederhana dulu, cukup label)
- Tombol **"Proses Transaksi"** → submit ke backend

---

## 5. Backend — Controller & Service

### Controller: `TransactionController`

| Method | Route | Fungsi |
|---|---|---|
| `GET` | `/transaction` | Render halaman utama |
| `GET` | `/transaction/products` | Ambil produk + kategori (JSON) |
| `POST` | `/transaction/checkout` | Simpan order + order_items |
| `GET` | `/transaction/discounts` | Ambil daftar diskon aktif (JSON) |
| `GET` | `/transaction/customers/search` | Search customer by name/phone (JSON) |

### Logika Checkout (`POST /transaction/checkout`)

1. Validasi input (items tidak kosong, quantity > 0)
2. Validasi stok setiap produk di DB (bukan dari client)
3. Generate `order_no` — format: `TRX-YYYYMMDD-XXX` (auto-increment per hari)
4. Hitung ulang subtotal, discount, tax, total di server (jangan percaya data dari client)
5. Simpan ke tabel `orders` dengan `status = 'paid'`
6. Simpan semua item ke `order_items` dengan `unit_price` snapshot dari DB saat itu
7. Kurangi `stock` di tabel `products`
8. Jika ada customer → update `loyalty_points` dan `total_spent`
9. Return JSON sukses + `order_id` untuk keperluan struk

Gunakan **database transaction** (`BEGIN` / `COMMIT` / `ROLLBACK`) untuk langkah 5–8.

---

## 6. Tabel yang Digunakan

| Tabel | Digunakan untuk |
|---|---|
| `products` | Tampil di grid, validasi stok, snapshot harga |
| `categories` | Tab filter produk |
| `orders` | Simpan header transaksi |
| `order_items` | Simpan detail item per transaksi |
| `customers` | Opsional — attach customer ke order |
| `discounts` | Pilih promo/diskon yang sedang aktif |
| `users` | `user_id` kasir diambil dari session |

---

## 7. State Cart (Client-side)

Kelola cart sepenuhnya di JavaScript (plain JS atau Vue/Alpine ringan).

```
cartState = {
  items: [{ product_id, name, unit_price, quantity, subtotal }],
  discount: { id, type, value },
  customer_id: null,
  subtotal: 0,
  tax: 0,
  total: 0
}
```

- Saat submit, serialisasi `cartState` → kirim sebagai JSON via `fetch` / AJAX POST
- Jangan simpan cart di session server (stateless)

---

## 8. UI & UX Notes

- Gunakan **font monospace** atau bold untuk angka harga agar mudah dibaca kasir
- Warna status stok: hijau = ada, merah = habis
- Keyboard shortcut opsional: `F2` = fokus search produk, `Enter` di modal = proses bayar
- Tampilan kembalian berwarna hijau jika cukup, merah jika kurang
- Setelah transaksi sukses → tampilkan **SweetAlert sukses** + opsi cetak struk
- Gunakan **loading state** di tombol "Proses Transaksi" saat request berjalan

---

## 9. Struktur File

```
app/
├── controllers/
│   └── TransactionController.php
├── services/
│   └── TransactionService.php       ← logika checkout & generate order_no
├── views/
│   └── transaction/
│       └── index.volt               ← layout dua kolom
└── public/
    └── js/
        └── pos-cart.js              ← state management cart
```

---

## 10. Out of Scope (tidak dikerjakan di sini)

- Halaman riwayat transaksi / laporan
- Fitur refund / void transaksi
- Manajemen diskon (CRUD discounts)
- Manajemen customer (CRUD customers)
- Cetak struk (bisa ditambah sebagai fase berikutnya)