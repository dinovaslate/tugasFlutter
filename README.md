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

---

## Tugas 8

### Checklist Implementasi

- [x] Menyiapkan backend Django (model `Product`, endpoint JSON/detail, auth login/register/logout) beserta konfigurasi deployment (ALLOWED_HOSTS `10.0.2.2`, CORS, SameSite, dan migrasi).
- [x] Membuat model Dart `Product` lengkap dengan parser JSON agar antarmuka Flutter mempunyai representasi data yang aman.
- [x] Mengembangkan halaman registrasi Flutter menggunakan package `http` untuk memanggil endpoint `/auth/register/`.
- [x] Mengembangkan halaman login Flutter yang memakai `CookieRequest` dan `Provider` sehingga sesi Django terbagi ke seluruh widget.
- [x] Mengimplementasikan halaman daftar item yang mengambil data dari endpoint JSON, menampilkan name/price/description/thumbnail/category/is_featured, serta memfilter item milik pengguna yang sedang login.
- [x] Menambahkan halaman detail item yang menampilkan seluruh atribut serta tombol kembali ke daftar.
- [x] Memperbarui drawer + tombol logout agar sesi dapat dihentikan dari Flutter dan kembali ke halaman login.
- [x] Menulis jawaban pertanyaan refleksi dan merangkum langkah implementasi pada README.

### Jawaban Pertanyaan

1. **Mengapa membuat model Dart saat bekerja dengan JSON?**  
   Model memberi kontrak tipe yang eksplisit sehingga setiap field wajib melalui validasi ketika diparsing. Tanpa model kita hanya memanipulasi `Map<String, dynamic>` sehingga kesalahan typo kunci, nilai `null`, atau perubahan struktur dari backend baru akan terlihat saat runtime dan berpotensi memicu crash. Dengan model, compiler membantu mengecek null-safety, konversi angka/boolean, sekaligus memudahkan refactor karena pemakaian properti tercatat sebagai referensi kode.

2. **Peran package `http` dan `CookieRequest`.**  
   Package `http` dipakai untuk permintaan stateless yang tidak membutuhkan sesi, contohnya registrasi akun (`POST /auth/register/`) karena pengguna belum memiliki cookie. `CookieRequest` dari `pbp_django_auth` menangani operasi yang membutuhkan session + CSRF (login, logout, dan seluruh permintaan setelah autentikasi) sekaligus menyimpan cookie secara otomatis. Dengan demikian `http` fokus pada request ringan, sedangkan `CookieRequest` menjaga autentikasi berbasis cookie milik Django.

3. **Mengapa `CookieRequest` dibagikan ke semua komponen?**  
   `CookieRequest` menyimpan status login, header, serta cookie sesi yang harus konsisten untuk setiap request. Jika setiap widget membuat instance baru, cookie tidak akan tersinkronisasi sehingga sebagian halaman mengira pengguna belum login. Dengan menyediakan `CookieRequest` melalui `Provider`, seluruh widget membaca instance yang sama sehingga status `loggedIn`, data profil, dan cookie selalu mutakhir tanpa perlu meneruskan parameter secara manual.

4. **Konfigurasi konektivitas Flutter ↔ Django.**  
   Emulator Android mengakses host melalui `10.0.2.2`, sehingga domain tersebut harus muncul di `ALLOWED_HOSTS` dan `CSRF_TRUSTED_ORIGINS` agar Django menerima request. `django-cors-headers` membuka akses lintas origin sekaligus mengizinkan cookie dikirim dengan `CORS_ALLOW_CREDENTIALS`. Pengaturan `SESSION_COOKIE_SAMESITE`/`CSRF_COOKIE_SAMESITE` memastikan cookie tidak diblok karena dianggap third-party. Di sisi Flutter, AndroidManifest memerlukan `android.permission.INTERNET` supaya aplikasi dapat mengakses jaringan. Jika salah satu konfigurasi terlewat, request akan ditolak (HTTP 400/403), cookie tidak pernah terset, atau aplikasi gagal membuka koneksi jaringan sama sekali.

5. **Mekanisme aliran data dari input sampai tampil di Flutter.**  
   `HomePage` memanggil endpoint `/products/json/` melalui `CookieRequest`. Response JSON dipetakan ke daftar `Product` menggunakan konstruktor `fromJson`. Widget `FutureBuilder` menunggu future tersebut, kemudian meneruskan setiap `Product` ke `ItemCard` untuk dirender. Ketika pengguna menarik RefreshIndicator, Future baru dibuat sehingga data terbaru yang sudah difilter oleh username akan tampil kembali.

6. **Mekanisme autentikasi login/register/logout.**  
   Pada register, form Flutter mengirim JSON lewat `http.post` ke `/auth/register/`; view Django memproses `UserCreationForm` dan mengembalikan status sukses/error. Saat login, Flutter menjalankan `CookieRequest.login` sehingga Django melakukan `authenticate` dan, ketika sukses, mengisi session + cookie CSRF yang disimpan otomatis oleh `CookieRequest`. Semua permintaan selanjutnya (GET item/POST logout) menggunakan cookie tersebut. Logout memanggil `/auth/logout/`, Django menghapus session, lalu Flutter mengarahkan pengguna kembali ke halaman login dan mengosongkan state `CookieRequest`.

7. **Langkah implementasi checklist (ringkas).**
   1. Mendesain model `Product` di Django, menambahkan relasi `owner`, membuat view JSON/detail, serta endpoint auth register/login/logout.  
   2. Mengaktifkan konfigurasi deployment (`ALLOWED_HOSTS`, CORS, SameSite) dan menjalankan `makemigrations` + `migrate` untuk memastikan backend siap.  
   3. Membuat model Dart `Product`, menambahkan dependency (`http`, `pbp_django_auth`, `provider`), dan memberi izin internet pada Android.  
   4. Membangun ulang arsitektur Flutter: `LoginPage`, `RegisterPage`, `HomePage`, `ItemDetailPage`, serta drawer baru yang terhubung ke provider `CookieRequest`.  
   5. Menghubungkan `HomePage` dengan endpoint Django menggunakan `CookieRequest`, memfilter data berdasarkan `ownerUsername`, dan menampilkan detail card + halaman detail lengkap.  
   6. Menyediakan tombol logout yang memanggil endpoint Django lalu menavigasi ulang ke halaman login.  
   7. Menguji alur register → login → melihat daftar → membuka detail → logout dan memperbarui README sesuai pertanyaan.
