# Planning: Halaman Dashboard POS

> Stack: PHP 7.3 · Phalcon 3.4.5 · PostgreSQL · AdminLTE / Bootstrap 4  
> Scope: Halaman dashboard ringkasan bisnis untuk role ADMIN & Kasir

---

## 1. Gambaran Halaman

Layout satu halaman penuh dengan beberapa section vertikal:

```
┌─────────────────────────────────────────────────────┐
│  HEADER — Filter Periode (Today / Week / Month)     │
├──────────┬──────────┬──────────┬────────────────────┤
│ Total    │ Total    │ Jumlah   │ Rata-rata           │
│ Pendapatan│ Order   │ Customer │ Nilai per Order     │
├──────────┴──────────┴──────────┴────────────────────┤
│  GRAFIK — Pendapatan per Hari (Line / Bar Chart)    │
├─────────────────────────┬───────────────────────────┤
│  Produk Terlaris        │  Transaksi Terbaru        │
├─────────────────────────┴───────────────────────────┤
│  Stok Hampir Habis                                  │
└─────────────────────────────────────────────────────┘
```

---

## 2. Komponen & Data Source

### 2.1 Summary Cards (4 Kartu Atas)

| Kartu | Query dari | Keterangan |
|---|---|---|
| Total Pendapatan | `orders.total` WHERE `status = 'paid'` | Sum by periode |
| Total Order | `orders` | Count by periode |
| Jumlah Customer Baru | `customers` | Count by `created_at` periode (jika ada kolom) |
| Rata-rata Nilai Order | Total Pendapatan / Total Order | Hitung di PHP |

Filter periode: **Today / This Week / This Month** — via query param `?period=today`

---

### 2.2 Grafik Pendapatan

- Tipe: **Line chart** atau **Bar chart** (gunakan Chart.js)
- X-axis: Tanggal (per hari dalam periode)
- Y-axis: Total pendapatan (`SUM(total)`)
- Query: `GROUP BY DATE(created_at)` dari tabel `orders` WHERE `status = 'paid'`
- Data dikirim dari backend sebagai JSON via endpoint terpisah

---

### 2.3 Tabel Produk Terlaris

- Kolom: Nama produk, Kategori, Total Qty Terjual, Total Pendapatan
- Query: JOIN `order_items` + `products` + `categories`, GROUP BY `product_id`, ORDER BY `SUM(quantity) DESC`
- Limit: Top 5 atau Top 10
- Filter ikut periode yang dipilih

---

### 2.4 Tabel Transaksi Terbaru

- Kolom: Order No, Kasir, Customer, Total, Status, Waktu
- Query: `orders` JOIN `users` LEFT JOIN `customers`, ORDER BY `created_at DESC`
- Limit: 10 transaksi terakhir
- Klik baris → redirect ke halaman detail transaksi
- Tidak ikut filter periode (selalu tampilkan 10 terbaru)

---

### 2.5 Peringatan Stok Hampir Habis

- Tampil sebagai tabel atau card warning (warna kuning / merah)
- Query: `products` WHERE `stock <= threshold` AND `is_active = true`
- Threshold: bisa hardcode dulu (misal stok ≤ 5)
- Kolom: Nama produk, Kategori, Stok sisa
- Klik → redirect ke halaman edit produk

---

## 3. Backend — Controller & Endpoint

### Controller: `DashboardController`

| Method | Route | Fungsi |
|---|---|---|
| `GET` | `/dashboard` | Render halaman utama dashboard |
| `GET` | `/dashboard/summary` | Return JSON summary cards |
| `GET` | `/dashboard/chart` | Return JSON data grafik pendapatan |
| `GET` | `/dashboard/top-products` | Return JSON produk terlaris |
| `GET` | `/dashboard/recent-orders` | Return JSON transaksi terbaru |
| `GET` | `/dashboard/low-stock` | Return JSON produk stok tipis |

Semua endpoint JSON mendukung query param `?period=today|week|month`

---

## 4. Logika Filter Periode

Terjemahkan `period` ke range tanggal di PHP sebelum query:

| Period | Range |
|---|---|
| `today` | `DATE = CURRENT_DATE` |
| `week` | `DATE >= DATE_TRUNC('week', NOW())` |
| `month` | `DATE >= DATE_TRUNC('month', NOW())` |

Default: `today`

---

## 5. Rendering Strategy

- Halaman di-render server-side oleh Phalcon (Volt)
- Data summary & grafik diambil via **AJAX saat halaman load**
- Saat user ganti filter periode → AJAX ulang semua endpoint
- Gunakan **loading skeleton** atau spinner saat data sedang diambil
- Tidak ada auto-refresh (manual reload cukup untuk dashboard kasir)

---

## 6. Role-based Visibility

| Komponen | ADMIN | Kasir (USER) |
|---|---|---|
| Summary cards | ✅ Semua | ✅ Hanya order hari ini |
| Grafik pendapatan | ✅ | ❌ Disembunyikan |
| Produk terlaris | ✅ | ❌ Disembunyikan |
| Transaksi terbaru | ✅ Semua kasir | ✅ Hanya milik sendiri |
| Stok hampir habis | ✅ | ✅ |

---

## 7. Struktur File

```
app/
├── controllers/
│   └── DashboardController.php
├── services/
│   └── DashboardService.php       ← semua query & kalkulasi
├── views/
│   └── dashboard/
│       └── index.volt             ← layout dashboard
└── public/
    └── js/
        └── dashboard.js           ← AJAX calls & render Chart.js
```

---

## 8. Out of Scope

- Export laporan ke PDF / Excel
- Dashboard real-time (WebSocket)
- Notifikasi push stok habis
- Multi-outlet / multi-branch summary