<h1 align="center">Football Shop Flutter App</h1>

Dashboard Flutter sederhana bertema Football Shop yang digunakan untuk mempraktikkan navigasi, layout, serta form input.

## Cara Menjalankan

Pastikan Flutter SDK (folder `flutter`) sudah tersedia di environment lokal. Kemudian jalankan perintah berikut dari direktori proyek.

```bash
flutter run
```

---

## Tugas 6

### Ringkasan Implementasi

- Mengatur tema aplikasi menggunakan warna hijau Football Shop dan tipografi Poppins dari `google_fonts`.
- Menyusun halaman utama dengan ikon produk, teks sambutan, serta tiga tombol aksi menggunakan kombinasi `Column`, `SizedBox`, dan `ElevatedButton.icon`.
- Menampilkan `SnackBar` melalui `ScaffoldMessenger` ketika setiap tombol ditekan.

### Jawaban Pertanyaan

1. **Perbedaan stateless vs stateful widget**  
   Stateless widget tidak mempunyai state internal dan hanya bergantung pada parameter konstruktor sehingga tampilannya tidak berubah setelah dibuat. Stateful widget memiliki objek `State` yang dapat menyimpan data dan berubah melalui `setState()`, membuat UI dapat diperbarui selama siklus hidup widget.

2. **Widget yang digunakan dan fungsinya**  
   `MaterialApp` sebagai root aplikasi, `Scaffold` untuk kerangka halaman, `AppBar` sebagai judul, `Container` dan `Padding` untuk tata letak, `Column` dan `SizedBox` untuk komposisi vertikal, `Icon` dan `Text` untuk konten, `ElevatedButton.icon` sebagai tombol aksi, serta `SnackBar` dan `ScaffoldMessenger` untuk umpan balik.

3. **Fungsi `setState()`**  
   `setState()` memberi tahu Flutter bahwa ada perubahan data pada state sehingga metode `build()` dijalankan ulang dan UI diperbarui. Karena halaman utama bersifat stateless pada tugas ini, tidak ada variabel yang dipengaruhi.

4. **Perbedaan `const` dan `final`**  
   `const` menghasilkan nilai yang bersifat konstan saat kompilasi (compile-time constant) dan tidak dapat berubah sama sekali. `final` hanya dapat diinisialisasi sekali, namun nilainya boleh ditentukan saat runtime. Semua `const` bersifat `final`, sementara tidak semua `final` adalah `const`.

---

## Tugas 7

### Checklist Implementasi

- [x] Menambahkan halaman form tambah produk (`ProductFormPage`) dengan input nama, harga, deskripsi, kategori, URL thumbnail, dan switch produk unggulan.
- [x] Validasi setiap input: wajib diisi, panjang minimal, harga positif, serta URL dengan skema `http/https`.
- [x] Tombol **Save** menampilkan dialog berisi rekap data form.
- [x] Tombol **Tambah Produk** di halaman utama menavigasi ke halaman form dengan `Navigator.push`.
- [x] Drawer dengan opsi **Halaman Utama** dan **Tambah Produk** yang menavigasi ke halaman terkait menggunakan `Navigator.pushReplacement`.
- [x] README diperbarui dengan jawaban pertanyaan baru.

### Jawaban Pertanyaan

1. **Perbedaan `Navigator.push()` dan `Navigator.pushReplacement()`**  
   `Navigator.push()` menambahkan route baru di atas tumpukan sehingga pengguna dapat kembali ke halaman sebelumnya melalui tombol back. Contohnya, tombol **Tambah Produk** pada beranda memanggil `Navigator.push()` agar pengguna bisa kembali setelah selesai mengisi form. Sebaliknya, `Navigator.pushReplacement()` mengganti route aktif sehingga halaman sebelumnya dihapus dari tumpukan. Drawer menggunakan `Navigator.pushReplacement()` untuk berpindah antar-halaman karena pola drawer biasanya tidak menumpuk riwayat halaman.

2. **Pemanfaatan hierarchy widget (`Scaffold`, `AppBar`, `Drawer`)**  
   Setiap halaman menggunakan `Scaffold` sebagai kerangka utama sehingga konten, `AppBar`, dan `Drawer` tersusun konsisten. `AppBar` menyediakan judul dan gaya yang sama di beranda maupun halaman form, sedangkan `Drawer` dibagi ke dalam widget terpisah (`AppDrawer`) agar navigasi dan gaya drawer tetap seragam tanpa duplikasi kode.

3. **Kelebihan `Padding`, `SingleChildScrollView`, dan `ListView` untuk elemen form**  
   `Padding` menjaga jarak antar-field agar mudah dibaca. `SingleChildScrollView` mencegah overflow ketika form dibuka pada layar kecil atau saat keyboard muncul karena seluruh isi form dapat digulir. Untuk menampilkan rekap data form di dialog, `ListView` digunakan sehingga daftar nilai tetap dapat digulir apabila kontennya panjang. Kombinasi ketiganya menjaga form tetap nyaman digunakan di berbagai ukuran layar.

4. **Menyesuaikan warna tema agar konsisten dengan brand**  
   Tema aplikasi menggunakan `ColorScheme.fromSeed` dengan warna hijau Football Shop (`0xFF1B5E20`) dan dipadukan dengan teks Poppins. Warna yang sama diterapkan pada `AppBar`, drawer header, serta aksi utama sehingga identitas visual toko terasa konsisten di seluruh halaman.
