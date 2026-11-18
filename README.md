# Personal Portfolio (mobile ver)
Nama : Tania Ju

NPM : 2506608123

Kelas : PBP A

## Logbook Progres Mingguan

| Minggu | Tanggal | Progress / Fitur yang Dikerjakan | Tugas |
| :---: | :--- | :--- | :--- |
| **1** | 09 - 15 Nov 2026 | Setup proyek Flutter, `MyHomePage` stateless di `menu.dart`, tiga `InfoCard`, dan tiga `ItemCard` berwarna dengan *SnackBar* | Tugas 7: Basic Flutter |
| **2** | 16 - 22 Nov 2026 | Membuat form dan validasi, serta navigasi dari kartu aksi dan drawer | Tugas 8: Navigation, Layouts, Forms, and Input Elements |
---

<details>
<summary>Tugas 7</summary>

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
2.  **Kerangka Pertanyaan Reflektif:** AI membantu mengevaluasi jawaban saya untuk keenam pertanyaan. Saya melengkapi jawaban yang masih kurang dengan masukan AI menggunakan kalimat sendiri dan menyesuaikannya dengan kode proyek saya.

    **Perbaikan Manual & Keterbatasan AI:**
AI tidak bisa melihat perubahan lokal saya, sehingga status checklist terbaru harus saya verifikasi sendiri. Perubahan manual dilakukan sesuai perintah tugas serta pembersihan line yang sudah tidak terpakai (misalnya import di test).

</details>

<details>
<summary>Tugas 8</summary>

1. **Perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode yang digunakan untuk membuka formulir dari kartu aksi dan cara opsi Home di drawer membawa pengguna kembali ke halaman utama.**

Navigator menyimpan halaman sebagai stack. Push menambahkan halaman baru di atas stack, jadi halaman sebelumnya masih ada di bawahnya. PushReplacement mengganti halaman paling atas dengan halaman baru, jadi halaman lama dibuang dari stack. Pop menghapus halaman paling atas sehingga pengguna kembali ke halaman di bawahnya.
- Kartu Tambah Proyek dan Tambah Pengalaman memakai Navigator.push(), sehingga tumpukannya menjadi {Menu, Form}. Tombol Back perangkat atau browser akan menjalankan pop dan kembali ke menu.
- Opsi Home di drawer memakai Navigator.pushReplacement() ke MyHomePage. Halaman form yang sedang dibuka diganti dengan halaman utama, jadi pengguna langsung berada di halaman utama tanpa form di atasnya.
- Pop juga dipakai pada tombol OK di dialog ringkasan untuk menutup dialog dan kembali ke formulir.

2. **Bagaimana susunan Scaffold, AppBar, dan Drawer membantu menjaga struktur halaman tetap konsisten. Contoh penggunaan warna tema portofolio di lebih dari satu halaman.**

Scaffold menyediakan kerangka yang sama untuk setiap halaman, yaitu AppBar di atas, Drawer di kiri, dan body untuk isi. Halaman utama, form proyek, dan form pengalaman sama-sama memakai Scaffold dengan AppBar dan LeftDrawer yang sama, sehingga posisi judul, tombol menu, dan isi navigasi selalu sama di setiap halaman. Drawer cukup dibuat sekali di left_drawer.dart, jadi opsi baru seperti Add Experience cukup ditambahkan di satu file.

Contoh warna tema: di main.dart tema dibuat dari seedColor indigo. Warna primary dari tema itu dipakai sebagai warna AppBar di halaman utama, dan juga sebagai warna AppBar serta tombol Simpan di form pengalaman. Kalau seedColor diubah, warna kedua halaman ikut berubah bersamaan.

3. **Alasan memilih tata letak formulir. Peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.**

Formulir disusun sebagai Form, lalu SingleChildScrollView, lalu Column, dengan input berurutan dari atas ke bawah. Susunan vertikal dipilih karena formulir diisi berurutan seperti di web, dan setiap field mendapat lebar penuh sehingga label, isian, dan pesan error terbaca jelas di layar ponsel yang sempit.
- Sebagai pengatur jarak: setiap field dibungkus Padding agar ada jarak antar-kolom dan dari tepi layar, sehingga field tidak berdempetan dan mudah disentuh. Di dialog ringkasan, SizedBox memberi jarak antarbaris.
- Sebagai penggulir: SingleChildScrollView membuat isi form bisa di-scroll. Saat keyboard muncul, area layar mengecil, sehingga tanpa scroll field di bawah dan tombol Simpan akan tertutup atau overflow. Isi dialog ringkasan juga dibungkus SingleChildScrollView agar tetap bisa dibaca kalau panjang.

4. **Peran GlobalKey<FormState>, validator, dan validate() saat tombol Simpan ditekan. Contoh nilai yang ditolak oleh validasi dan alasan memilih jenis input atau papan ketik saja belum cukup.**

- GlobalKey<FormState> dipasang di Form agar tombol Simpan bisa mengakses state formulir dari luar field.
- Validator adalah fungsi di setiap field yang mengembalikan pesan error jika isian salah, atau null jika benar. Aturan yang dipakai bersama (wajib diisi, batas panjang, format URL) dibuat reusable lewat form_validators.dart.
- Validate() menjalankan semua validator sekaligus, menampilkan pesan error di bawah field yang salah, dan mengembalikan true hanya jika semuanya valid. Dialog ringkasan baru dibuka jika hasilnya true.
Contoh nilai yang ditolak: Nama Pengalaman yang hanya berisi spasi ditolak dengan pesan "Nama pengalaman tidak boleh kosong!". URL gambar tanpa http:// atau https:// juga ditolak, serta tanggal selesai yang lebih awal dari tanggal mulai.

Jenis input saja belum cukup karena hanya membatasi cara mengisi, bukan isi datanya. Keyboard URL hanya mengubah tata letak keyboard, tetapi pengguna tetap bisa mengetik teks yang bukan URL. Keyboard teks tetap mengizinkan isian yang hanya spasi. Date picker memastikan isinya tanggal, tetapi tidak tahu bahwa tanggal selesai harus setelah tanggal mulai. Aturan seperti ini hanya bisa dicek oleh validator.
 
**AI Disclosure & Manual Refinement**
 
Dalam pengerjaan proyek myportofolio-mobile (Tugas 8), sejauh ini saya memanfaatkan *Generative AI (claude)* sebagai pendiskusi teknis. Saya tetap melakukan intervensi teknis dan keputusan secara manual:
 
1.  **Penyesuaian Form dengan Web:** AI membantu menyesuaikan form proyek dengan model Project di web dan membantu memindahkan validator yang dipakai ulang ke file validator bersama.
2.  **Kerangka Pertanyaan Reflektif:** AI membantu mengevaluasi jawaban saya untuk keenam pertanyaan. Saya melengkapi jawaban yang masih kurang dengan masukan AI menggunakan kalimat sendiri dan menyesuaikannya dengan kode proyek saya.

    **Perbaikan Manual & Keterbatasan AI:**
Saya menanyakan ulang bagian kode yang belum saya pahami sebelum memakainya, lalu merapikan dan/atau menambahkan komentar sesuai gaya saya. AI juga tidak bisa menjalankan Flutter maupun membuka web deploy saya, sehingga flutter analyze, pengujian di Chrome, dan pengecekan alur navigasi saya lakukan sendiri.

</details>