-- CREATE EXTENSION "uuid-ossp";
-- SELECT uuid_generate_v4();
CREATE EXTENSION IF NOT EXISTS pgcrypto;
SELECT gen_random_uuid();

CREATE TABLE users(  
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    role VARCHAR(255) DEFAULT ('ADMIN', 'USER'),
    username VARCHAR(255),
    password VARCHAR(255),
    is_active BOOLEAN
);
COMMENT ON TABLE users IS 'table untuk menyimpan data user POS yang digunakan untuk login.';

CREATE TABLE products(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID,
    name VARCHAR(255),
    description VARCHAR(255),
    stock INT,
    price INT,
    is_active BOOLEAN
);
COMMENT ON TABLE products IS 'table untuk menyimpan data produk.';

CREATE TABLE categories(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    description VARCHAR(255),
    is_active BOOLEAN,
    sort_order INT
);
COMMENT ON TABLE categories IS 'table untuk menyimpan data kategori produk.';
COMMENT ON COLUMN categories.sort_order IS 'Integer untuk urutan tampilan di menu POS. Kasir bisa drag-reorder kategori.';

CREATE TABLE orders(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    customer_id UUID,
    order_no VARCHAR(255),
    subtotal NUMERIC,
    discount NUMERIC,
    tax NUMERIC,
    total NUMERIC,
    status VARCHAR(255),
    created_at TIMESTAMP
);
COMMENT ON TABLE orders IS 'table untuk menyimpan data order.';
COMMENT ON COLUMN orders.order_no IS 'Nomor transaksi yang human-readable. Format: TRX-20240315-001. UNIQUE per transaksi.';
COMMENT ON COLUMN orders.status IS 'ENUM: pending | paid | partial | cancelled | refunded. Gunakan state machine untuk transisi status.';

CREATE TABLE order_items(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID,
    product_id UUID,
    quantity INT,
    unit_price NUMERIC,
    discount NUMERIC,
    subtotal NUMERIC
);
COMMENT ON TABLE order_items IS 'table untuk menyimpan detail order.';
COMMENT ON COLUMN order_items.unit_price IS 'SNAPSHOT harga saat transaksi. Jangan ambil dari products.base_price saat query, karena harga bisa berubah.';

CREATE TABLE customers(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    phone VARCHAR(255),
    loyality_points INT,
    total_spent NUMERIC
);
COMMENT ON TABLE customers IS 'table untuk menyimpan data customer.';
COMMENT ON COLUMN customers.loyality_points IS 'Saldo poin yang bisa ditukarkan. Update via trigger atau service layer saat order selesai.';
COMMENT ON COLUMN customers.total_spent IS 'Denormalized aggregate untuk performa dashboard CRM. Update via trigger/job, bukan hitung ulang setiap saat.';

CREATE TABLE discounts(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    type VARCHAR(255),
    value NUMERIC,
    valid_from DATE,
    valid_until DATE
);
COMMENT ON TABLE discounts IS 'valid_from dan valid_until adalah Range tanggal aktif promo. Validasi di aplikasi DAN di DB untuk double protection.';
COMMENT ON COLUMN discounts.type IS 'percentage | fixed_amount | buy_x_get_y | free_shipping. Tentukan logika kalkulasi.';