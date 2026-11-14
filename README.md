# Personal Portfolio (mobile ver)
Nama : Tania Ju

NPM : 2506608123

Kelas : PBP A

## Logbook Progres Mingguan

| Minggu | Tanggal | Progress / Fitur yang Dikerjakan | Tugas |
| :---: | :--- | :--- | :--- |
| **1** | 09 - 15 Nov 2026 | Setup proyek Flutter, `MyHomePage` stateless di `menu.dart`, tiga `InfoCard`, dan tiga `ItemCard` berwarna dengan *SnackBar* | Tugas 7: Basic Flutter |

### Tugas 7
1. **Widget tree pada Flutter dan bagaimana hubungan induk anak (parent-child) bekerja antar-widget.** Widget tree pada Flutter adalah susunan hierarkis seperti pohon semua widget, dari MyApp sebagai akar sampai Text dan Icon sebagai leaf. Anak dipasang lewat child (singular) atau children (plural). Penjelasan lebih lanjut tentang hubungan parent-child: 
- Parent adalah widget yang membungkus widget lain (child). Contoh: Column adalah parent dari WelcomeBanner dan Row, Row adalah parent dari tiga Expanded.
- Parent memberi batasan ukuran ke child, child menentukan ukurannya dan melaporkannya ke parent, lalu parent menentukan posisinya. Karena itu Expanded harus berada di dalam Row atau Column.
- Data mengalir dari parent ke child lewat konstruktor, misalnya MyHomePage mengirim npm, nama, dan kelas ke InfoCard, serta objek ItemHomepage ke ItemCard.
- Saat sebuah widget berubah, hanya widget itu dan anak-anaknya yang dibangun ulang, bukan seluruh aplikasi.

2. **Semua widget yang saya gunakan dalam proyek ini dan fungsinya masing-masing.**
- Sebagai kerangka: MaterialApp, Scaffold, AppBar, SafeArea (menghindari notch), SingleChildScrollView (scrollable)
- Sebagai tata letak: Column, Row, Expanded, SizedBox, Padding, Center, GridView.count, Container, FittedBox
- Sebagai tampilan: Text, Icon, Card, CircleAvatar
- Sebagai interaksi: Material, InkWell (touch & ripple effect), SnackBar (pesan singkat di bawah layar)
- MyApp: sebagai widget root (StatelessWidget), menetapkan judul aplikasi, tema, dan halaman awal (konfigurasi seluruh aplikasi)
- MyHomePage: sebagai halaman utama (StatelessWidget), menyimpan data identitas dan menyusun halaman dengan Scaffold
- WelcomeBanner: sebagai banner sambutan berisi icon avatar dan teks.
- InfoCard: sebagai kartu informasi yang reusable, untuk menampilkan data NPM, nama, dan kelas
- ItemCard: sebagai kartu button aksi yang reusable dan memunculkan SnackBar saat ditekan

3. **Fungsi dari widget MaterialApp. Alasan widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter.**
Menyediakan tema (ThemeData), navigasi (Navigator), dan home. Widget ini jadi root untuk kebutuhan widget Material di bawahnya.

4. **Perbedaan antara StatelessWidget dan StatefulWidget! Kapan sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget.**
Stateless tidak menyimpan data yang berubah, tampilannya hanya bergantung pada input konstruktor. Stateful punya objek State dan memanggil setState() untuk menggambar ulang. Pilih Stateless ketika halaman hanya butuh tampilan statis seperti halaman menu, dan Stateful untuk halaman interaktif seperti counter, form, atau animasi.

5. **Apa itu BuildContext dan alasan penting di Flutter. Cara penggunaannya di dalam metode build**
BuildContext adalah penanda posisi sebuah widget di dalam tree. Penting karena dipakai untuk mencari data dari root, tanpa context, data seperti tema harus dikirim lewat konstruktor ke setiap widget. Di metode build, saya pakai pada Theme.of(context).colorScheme dan ScaffoldMessenger.of(context). Cara pakai di metode build:
- Flutter memanggil build(BuildContext context) dan mengisi parameter context secara otomatis. Setiap widget mendapat context miliknya sendiri, sesuai posisinya di tree.
- Context dipakai lewat pola NamaWidget.of(context), yang mencari ke atas tree sampai menemukan root terdekat bertipe tersebut.

6. **Konsep hot reload di Flutter dan perbedaannya dengan hot restart. Kapan tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart.**
Hot reload menyuntikkan kode baru dan menjalankan ulang build tanpa menghapus state, hasilnya terlihat dalam hitungan detik. Hot restart menjalankan aplikasi dari main() lagi dan state hilang. Hot reload tidak cukup kalau mengubah main(), initState, atau nilai awal variabel global dan static. Full restart diperlukan kalau mengubah kode native atau menambah dependency di pubspec.yaml.

**AI Disclosure & Manual Refinement**

Dalam pengerjaan proyek myportofolio-mobile (Tugas 7), sejauh ini saya memanfaatkan *Generative AI (claude)* sebagai pendiskusi teknis. Saya tetap melakukan intervensi teknis dan keputusan secara manual:

1.  **Pemahaman Layout & Widget:** AI membantu menjelaskan fungsi tiap bagian kode, misalnya peran Expanded di dalam Row, serta FittedBox agar teks tidak overflow.
3.  **Kerangka Pertanyaan Reflektif:** AI membantu mengevaluasi jawaban saya untuk keenam pertanyaan. Saya melengkapi jawaban yang masih kurang dengan masukan AI menggunakan kalimat sendiri dan menyesuaikannya dengan kode proyek saya.

    **Perbaikan Manual & Keterbatasan AI:**
AI tidak bisa melihat perubahan lokal saya, sehingga status checklist terbaru harus saya verifikasi sendiri. Perubahan manual dilakukan sesuai perintah tugas serta pembersihan line yang sudah tidak terpakai (misalnya import di test).