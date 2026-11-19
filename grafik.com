Buatkan WEBSITE DASHBOARD GRAFIK KEUANGAN menggunakan HTML, CSS, dan JavaScript yang bisa dijalankan melalui GitHub Pages.

PENTING:
Website WAJIB menampilkan grafik secara langsung ketika pertama kali dibuka. Jangan hanya membuat tabel atau angka statistik. Grafik harus benar-benar terlihat dan berfungsi di halaman website.

1. GRAFIK BATANG UTAMA (WAJIB ADA)
- Buat grafik batang (Bar Chart) yang terlihat besar di halaman utama.
- Tampilkan 12 bulan: Januari sampai Desember.
- Setiap bulan memiliki dua batang.
- Batang pertama adalah PEMASUKAN dengan warna HIJAU (#16A34A).
- Batang kedua adalah PENGELUARAN dengan warna MERAH (#DC2626).
- Sumbu X menampilkan nama bulan.
- Sumbu Y menampilkan nominal Rupiah.
- Tampilkan nominal di atas setiap batang.
- Tambahkan legenda Pemasukan dan Pengeluaran.
- Gunakan Chart.js.

2. GRAFIK GARIS (WAJIB ADA)
- Buat grafik perkembangan pemasukan dan pengeluaran.
- Garis pemasukan berwarna hijau.
- Garis pengeluaran berwarna merah.
- Tampilkan data selama 12 bulan.

3. GRAFIK LINGKARAN (WAJIB ADA)
- Buat Pie Chart untuk membandingkan total pemasukan dan pengeluaran.
- Hijau untuk pemasukan.
- Merah untuk pengeluaran.
- Tampilkan persentase masing-masing.

4. KARTU STATISTIK
Tampilkan empat kartu di atas grafik:
- Total pemasukan.
- Total pengeluaran.
- Saldo akhir.
- Jumlah transaksi.

5. DATA GRAFIK
Gunakan data contoh berikut:

Bulan: Januari sampai Desember.

Pemasukan:
[5000000, 6000000, 5500000, 7000000, 6500000, 7500000, 8000000, 7200000, 8500000, 9000000, 8800000, 10000000]

Pengeluaran:
[3000000, 3500000, 3200000, 4000000, 3800000, 4200000, 4500000, 4100000, 5000000, 4800000, 5200000, 5500000]

6. DESAIN WEBSITE
- Modern dan profesional.
- Background putih atau abu-abu muda.
- Warna hijau untuk semua elemen pemasukan.
- Warna merah untuk semua elemen pengeluaran.
- Grafik memiliki ukuran besar dan jelas.
- Setiap grafik ditempatkan dalam card terpisah.
- Responsif untuk laptop dan HP.

7. INTERAKTIVITAS
- Tooltip ketika grafik disentuh atau diklik.
- Grafik otomatis diperbarui jika data berubah.
- Tambahkan pilihan filter bulan.
- Tambahkan animasi grafik yang halus.

8. TEKNOLOGI
- HTML5.
- CSS3.
- JavaScript.
- Chart.js melalui CDN.
- Bisa dijalankan langsung menggunakan GitHub Pages.

9. STRUKTUR FILE
Buat:
- index.html
- style.css
- script.js

10. HASIL AKHIR
Saya ingin ketika website dibuka, langsung terlihat:
1. Empat kartu statistik.
2. Grafik batang pemasukan dan pengeluaran.
3. Grafik garis perkembangan keuangan.
4. Grafik lingkaran perbandingan pemasukan dan pengeluaran.

JANGAN hanya memberikan desain berupa gambar.
JANGAN membuat grafik sebagai gambar statis.
SEMUA GRAFIK HARUS DIBUAT MENGGUNAKAN CHART.JS DAN BENAR-BENAR BERFUNGSI.

Berikan kode lengkap ketiga file dan pastikan bisa langsung diunggah ke GitHub Pages tanpa error.
