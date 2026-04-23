riwayat transaksi

buatkan halaman riwayat transaksi berdasarkan data berikut:

pos_app=# select * from orders limit 5; 
                  id                  |               user_id                | customer_id |     order_no     | subtotal | discount |  tax  | total  | status |         created_at         
--------------------------------------+--------------------------------------+-------------+------------------+----------+----------+-------+--------+--------+----------------------------
 219a1786-9847-4e36-89d9-15e8ca2e9d40 | c8e46692-3d59-48c2-b6bd-e2aee8a4b2e2 |             | TRX-20260421-001 |    78000 |        0 |  8580 |  86580 | paid   | 2026-04-21 16:59:46.307408
 1c4a9ac5-07ca-46af-a8b1-97553cbf3d5b | c8e46692-3d59-48c2-b6bd-e2aee8a4b2e2 |             | TRX-20260421-002 |     4000 |        0 |   440 |   4440 | paid   | 2026-04-21 17:33:20.83465
 ba34cd13-fafa-451e-87df-9c3e79f7525e | c8e46692-3d59-48c2-b6bd-e2aee8a4b2e2 |             | TRX-20260421-003 |   116000 |        0 | 12760 | 128760 | paid   | 2026-04-21 20:06:15.25021
 b498eb94-9f85-4586-b526-827eff17794e | bd6188a0-7662-4c39-9f11-e5f21097be47 |             | TRX-20260421-004 |    12000 |        0 |  1320 |  13320 | paid   | 2026-04-21 20:25:22.37343
 2f3e4cdb-fabd-46c7-976b-5440c6e84d8f | bd6188a0-7662-4c39-9f11-e5f21097be47 |             | TRX-20260421-005 |    23000 |     5000 |  1980 |  19980 | paid   | 2026-04-21 21:27:57.988799
(5 rows)

pos_app=# select * from order_items limit 5;
                  id                  |               order_id               |              product_id              | quantity | unit_price | discount | subtotal 
--------------------------------------+--------------------------------------+--------------------------------------+----------+------------+----------+----------
 80ae8a71-df7e-48d9-a835-57d74b24b489 | 219a1786-9847-4e36-89d9-15e8ca2e9d40 | f1633396-4cfb-487c-9f4b-db5e93102923 |        1 |      26000 |        0 |    26000
 d7b8e6a7-bc72-42f3-ab30-56500e928930 | 219a1786-9847-4e36-89d9-15e8ca2e9d40 | c818a929-a926-4d52-a94d-2fe70b112811 |        1 |      28000 |        0 |    28000
 a8229f96-c30c-4f5a-9424-5f8b22e92b7c | 219a1786-9847-4e36-89d9-15e8ca2e9d40 | 8327cfa0-5aa0-48e2-b2d3-920a95ee9a60 |        2 |       8000 |        0 |    16000
 623d2435-f856-441b-a419-26255624e69f | 219a1786-9847-4e36-89d9-15e8ca2e9d40 | 596cee9c-d0f8-4667-bdac-030382c603c0 |        1 |       8000 |        0 |     8000
 8b0ab90a-c7c3-494d-988d-f472f71b4823 | 1c4a9ac5-07ca-46af-a8b1-97553cbf3d5b | 39bbeb3e-95fe-4119-93d4-1861f0b14cbc |        2 |       2000 |        0 |     4000
(5 rows)

pos_app=# select * from customers;
                  id                  |        name         |   phone    | loyality_points | total_spent                                                 
--------------------------------------+---------------------+------------+-----------------+-------------
 437a78be-24d4-4ccb-b48b-080edabab683 | Nia Nur Utami       | 9876543210 |                 |            
 e5a24b4c-520c-4228-8aca-d7a7548d0e42 | Muhammad Ridwan     | -          |               2 |       29304
 c2636265-c3fa-441d-85c1-d40cde14e6bb | M Abyasa Dzikrillah | 0123456789 |             114 |     1149750
(3 rows)

pos_app=# select * from users;
                  id                  |     name      | role  | username |             password             | is_active                                  
--------------------------------------+---------------+-------+----------+----------------------------------+-----------
 c8e46692-3d59-48c2-b6bd-e2aee8a4b2e2 | Administrator | ADMIN | admin    | e172dd95f4feb21412a692e73929961e | t
 13b66764-c118-4bb3-b047-d8d244c864e5 | Cashier 2     | USER  | user2    | 6ad14ba9986e3615423dfca256d04e3f | f
 bd6188a0-7662-4c39-9f11-e5f21097be47 | Cashier 1     | USER  | user1    | 6ad14ba9986e3615423dfca256d04e3f | t
(3 rows)

pos_app=# select * from discounts;
                  id                  |          name          |     type     | value | valid_from | valid_until                                         
--------------------------------------+------------------------+--------------+-------+------------+-------------
 ed0c160c-8a96-4921-b2e9-fbeb6c4f2e84 | Promo Bulan April 2026 | fixed_amount |  4000 | 2026-04-01 | 2026-04-30
 83cc8e55-2b99-45a5-8e5b-dcddbe1df601 | Promo 4:4 2026         | percentage   |    40 | 2026-04-01 | 2026-04-30
(2 rows)

pos_app=# select * from products limit 5;
                  id                  |             category_id              |        name         |                    description                    | stock | price | is_active 
--------------------------------------+--------------------------------------+---------------------+---------------------------------------------------+-------+-------+-----------
 9d8dd05f-3d9a-4566-9368-71692febae0e | 21c11837-dc99-468d-a105-6e1911c096fb | Nasi Goreng Spesial | Nasi goreng dengan telur, ayam, dan bumbu spesial |    50 | 35000 | t
 18951fe2-c06e-49bd-bd80-1e09ba4c1bf7 | 21c11837-dc99-468d-a105-6e1911c096fb | Mie Goreng Kuah     | Mie goreng dengan kuah kental dan lauk melimpah   |    45 | 32000 | t
 fddf0b4b-a1c4-45d9-8960-efe9f8c8bf17 | 21c11837-dc99-468d-a105-6e1911c096fb | Perkedel            | Kentang goreng dengan telur dan parmesan          |    70 | 15000 | t
 a99c4d27-5b31-4047-ac7f-6c2aefefc7f5 | 21c11837-dc99-468d-a105-6e1911c096fb | Tahu Goreng Tepung  | Tahu goreng tepung renyah dengan sambal           |    65 | 12000 | t
 d8e3a7e7-a7a5-4e86-b3e6-ca8918f59e99 | 1bd6a540-de38-477e-a5f8-02020fe09e89 | Telur Dadar         | Telur dadar dengan nasi dan sambal                |    55 | 20000 | t
(5 rows)


- List transaksi (filter by tanggal, status, kasir)
- Detail transaksi (header + item breakdown)
- Tampilkan status order (pending, paid, cancelled, refunded)
- Cetak struk / invoice
- Void / batalkan transaksi
- Refund transaksi + kembalikan stok