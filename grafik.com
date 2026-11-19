Buatkan sebuah WEBSITE GRAFIK KEUANGAN menggunakan HTML, CSS, dan JavaScript yang dapat di-hosting secara gratis menggunakan GitHub Pages.

KONSEP WEBSITE:
Website menampilkan grafik pemasukan dan pengeluaran dengan desain modern, profesional, minimalis, dan responsif.

1. DESAIN WEBSITE
- Background putih atau abu-abu muda.
- Desain modern dan profesional.
- Warna hijau (#16A34A) untuk pemasukan.
- Warna merah (#DC2626) untuk pengeluaran.
- Tampilan rapi seperti website statistik profesional.
- Responsif untuk laptop, komputer, dan HP.

2. GRAFIK UTAMA
- Buat grafik batang (Bar Chart).
- Batang hijau menunjukkan pemasukan.
- Batang merah menunjukkan pengeluaran.
- Tampilkan data Januari sampai Desember.
- Gunakan Chart.js.
- Tambahkan angka nominal pada grafik.
- Tambahkan legenda dan tooltip interaktif.
- Grafik diperbarui otomatis ketika data berubah.

3. DATA KEUANGAN
Buat contoh data pemasukan dan pengeluaran selama 12 bulan.
Gunakan mata uang Rupiah (Rp).
Sediakan fitur untuk mengubah data.

4. RINGKASAN DATA
Tampilkan:
- Total pemasukan.
- Total pengeluaran.
- Saldo akhir.
- Rata-rata pemasukan.
- Rata-rata pengeluaran.

5. GRAFIK TAMBAHAN
Buat grafik lingkaran (Pie Chart) untuk persentase pemasukan dan pengeluaran.
Buat grafik garis (Line Chart) untuk melihat perkembangan keuangan setiap bulan.

6. STRUKTUR FILE
Buat tiga file:
- index.html
- style.css
- script.js

7. TEKNOLOGI
- HTML5.
- CSS3.
- JavaScript.
- Chart.js.
- Tidak menggunakan backend.
- Bisa dijalankan langsung melalui GitHub Pages.

8. OUTPUT
Berikan kode lengkap untuk ketiga file.
Pastikan semua grafik dapat berjalan tanpa error.
Berikan panduan mengunggah file ke GitHub dan mengaktifkan GitHub Pages.

Hasil akhir harus berupa website grafik keuangan yang menarik, modern, profesional, dan interaktif.
