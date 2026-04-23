-- CREATE EXTENSION "uuid-ossp";
-- SELECT uuid_generate_v4();
CREATE EXTENSION IF NOT EXISTS pgcrypto;
SELECT gen_random_uuid();

CREATE TABLE users(  
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    role VARCHAR(255) DEFAULT ('ADMIN', 'USER') NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);
COMMENT ON TABLE users IS 'table untuk menyimpan data user POS yang digunakan untuk login.';

CREATE TABLE products(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    stock INT NOT NULL,
    price NUMERIC NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);
COMMENT ON TABLE products IS 'table untuk menyimpan data produk.';

CREATE TABLE categories(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INT DEFAULT 0
);
COMMENT ON TABLE categories IS 'table untuk menyimpan data kategori produk.';
COMMENT ON COLUMN categories.sort_order IS 'Integer untuk urutan tampilan di menu POS. Kasir bisa drag-reorder kategori.';

CREATE TABLE orders(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    customer_id UUID,
    order_no VARCHAR(255) UNIQUE NOT NULL,
    subtotal NUMERIC NOT NULL,
    discount NUMERIC NOT NULL,
    tax NUMERIC NOT NULL,
    total NUMERIC NOT NULL,
    status VARCHAR(255) NOT NULL DEFAULT ('pending', 'paid', 'partial', 'cancelled', 'refunded'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE orders IS 'table untuk menyimpan data order.';
COMMENT ON COLUMN orders.order_no IS 'Nomor transaksi yang human-readable. Format: TRX-20240315-001. UNIQUE per transaksi.';
COMMENT ON COLUMN orders.status IS 'ENUM: pending | paid | partial | cancelled | refunded. Gunakan state machine untuk transisi status.';

CREATE TABLE order_items(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INT NOT NULL,
    unit_price NUMERIC NOT NULL,
    discount NUMERIC DEFAULT 0 NOT NULL,
    subtotal NUMERIC NOT NULL
);
COMMENT ON TABLE order_items IS 'table untuk menyimpan detail order.';
COMMENT ON COLUMN order_items.unit_price IS 'SNAPSHOT harga saat transaksi. Jangan ambil dari products.base_price saat query, karena harga bisa berubah.';

CREATE TABLE customers(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    loyality_points INT DEFAULT 0,
    total_spent NUMERIC DEFAULT 0
);
COMMENT ON TABLE customers IS 'table untuk menyimpan data customer.';
COMMENT ON COLUMN customers.loyality_points IS 'Saldo poin yang bisa ditukarkan. Update via trigger atau service layer saat order selesai.';
COMMENT ON COLUMN customers.total_spent IS 'Denormalized aggregate untuk performa dashboard CRM. Update via trigger/job, bukan hitung ulang setiap saat.';

CREATE TABLE discounts(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    value NUMERIC NOT NULL,
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL
);
COMMENT ON TABLE discounts IS 'valid_from dan valid_until adalah Range tanggal aktif promo. Validasi di aplikasi DAN di DB untuk double protection.';
COMMENT ON COLUMN discounts.type IS 'percentage | fixed_amount | buy_x_get_y | free_shipping. Tentukan logika kalkulasi.';

CREATE TABLE settings (
   key VARCHAR(255) PRIMARY KEY,
   value TEXT,
   description TEXT,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO settings (key, value, description) VALUES 
('store_name', 'Captain POS', 'Nama toko atau outlet.'),
('tax_percentage', '11', 'Persentase Pajak (PPN).'),
('order_no_format', 'TRX-{Ymd}-{03d}', 'Format penomoran order. Placeholder: {Ymd} untuk tanggal, {ddd} untuk serial angka (sesuaikan jumlah digit).');