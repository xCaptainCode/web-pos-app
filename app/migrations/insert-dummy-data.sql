-- Insert Categories
INSERT INTO categories (name, description, is_active, sort_order) VALUES 
('MAKANAN', 'Kategori untuk makanan dan hidangan utama', true, 1),
('MINUMAN', 'Kategori untuk minuman dan beverages', true, 2),
('LAIN-LAIN', 'Kategori lainnya dan side dishes', true, 3);

-- Insert Products (20 Food Items)
INSERT INTO products (category_id, name, description, stock, price, is_active) VALUES 
-- MAKANAN (10 items)
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Nasi Goreng Spesial', 'Nasi goreng dengan telur, ayam, dan bumbu spesial', 50, 35000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Mie Goreng Kuah', 'Mie goreng dengan kuah kental dan lauk melimpah', 45, 32000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Soto Ayam Tradisional', 'Soto ayam dengan bumbu turmeric dan ayam berkualitas', 40, 28000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Gado-gado', 'Sayuran tahu dan telur dengan bumbu kacang kental', 35, 25000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Satay Ayam', 'Daging ayam tusuk panggang dengan saus kacang', 30, 40000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Lumpia Shanghai', 'Lumpia goreng isi daging dan sayuran', 60, 18000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Bakso Kuah', 'Bakso sapi dalam kuah kaldu gurih', 50, 26000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Fried Chicken', 'Ayam goreng crispy dengan bumbu rahasia', 55, 38000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Perkedel', 'Kentang goreng dengan telur dan parmesan', 70, 15000, true),
((SELECT id FROM categories WHERE name = 'MAKANAN'), 'Tahu Goreng Tepung', 'Tahu goreng tepung renyah dengan sambal', 65, 12000, true),
-- MINUMAN (5 items)
((SELECT id FROM categories WHERE name = 'MINUMAN'), 'Es Teh Manis', 'Teh manis dingin dengan es batu', 100, 8000, true),
((SELECT id FROM categories WHERE name = 'MINUMAN'), 'Jus Jeruk Segar', 'Jus jeruk alami tanpa pemanis buatan', 80, 15000, true),
((SELECT id FROM categories WHERE name = 'MINUMAN'), 'Es Kopi Hitam', 'Kopi hitam dingin dengan es batu', 90, 12000, true),
((SELECT id FROM categories WHERE name = 'MINUMAN'), 'Smoothie Buah', 'Smoothie campuran buah dengan yogurt', 70, 20000, true),
((SELECT id FROM categories WHERE name = 'MINUMAN'), 'Coconut Water', 'Air kelapa muda segar', 60, 18000, true),
-- LAIN-LAIN (5 items)
((SELECT id FROM categories WHERE name = 'LAIN-LAIN'), 'Telur Dadar', 'Telur dadar dengan nasi dan sambal', 55, 20000, true),
((SELECT id FROM categories WHERE name = 'LAIN-LAIN'), 'Tempe Goreng', 'Tempe goreng tepung dengan sambal', 75, 10000, true),
((SELECT id FROM categories WHERE name = 'LAIN-LAIN'), 'Kerupuk Udang', 'Kerupuk udang goreng renyah', 80, 8000, true),
((SELECT id FROM categories WHERE name = 'LAIN-LAIN'), 'Sayuran Tumis', 'Sayuran segar ditumis dengan bumbu', 40, 22000, true),
((SELECT id FROM categories WHERE name = 'LAIN-LAIN'), 'Nasi Putih', 'Nasi putih hangat menjadi pelengkap sempurna', 100, 8000, true);
