Buatkan halaman Manajemen Diskon / Promo berdasarkan data berikut: 

pos_app=# select * from discounts;
                  id                  |          name          |     type     | value | valid_from | valid_until
--------------------------------------+------------------------+--------------+-------+------------+-------------
 ed0c160c-8a96-4921-b2e9-fbeb6c4f2e84 | Promo Bulan April 2026 | fixed_amount |  4000 | 2026-04-01 | 2026-04-30
 83cc8e55-2b99-45a5-8e5b-dcddbe1df601 | Promo 4:4 2026         | percentage   |    50 | 2026-04-04 | 2026-04-04
(2 rows)

-  List diskon
-  Tambah diskon (nama, tipe, nilai, tanggal aktif)
-  Edit diskon
-  Hapus / nonaktifkan diskon
-  Validasi tanggal aktif (valid_from s/d valid_until)
-  Support tipe: percentage dan fixed_amount