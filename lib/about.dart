import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 60;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan Aplikasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Panduan Penggunaan Aplikasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildFeatureSection(
              'Login',
              'Cara Menggunakan Fitur Login:',
              [
                'Masukkan alamat email dan password yang valid',
                'Klik tombol "Login" untuk masuk ke aplikasi',
                'Jika belum memiliki akun, gunakan fitur "Register"',
                'Aplikasi akan menyimpan sesi login Anda'
              ],
              Icons.login,
            ),
            _buildFeatureSection(
              'Konversi Waktu',
              'Cara Menggunakan Fitur Konversi Waktu:',
              [
                'Masukkan nilai tahun yang ingin dikonversi pada kolom input',
                'Pilih satuan konversi (Jam, Menit, atau Detik) dari dropdown',
                'Hasil konversi akan otomatis ditampilkan',
                'Gunakan tombol "X" untuk mengosongkan input',
                'Hasil akan mempertimbangkan tahun kabisat secara otomatis'
              ],
              Icons.access_time,
            ),
            _buildFeatureSection(
              'Cek Jenis Bilangan',
              'Cara Menggunakan Fitur Cek Jenis Bilangan:',
              [
                'Masukkan bilangan yang ingin Anda cek pada kolom input',
                'Klik tombol "Check Jenis Bilangan" untuk melihat hasilnya',
                'Aplikasi akan menampilkan apakah bilangan tersebut termasuk: prima, desimal, positif, negatif, atau cacah',
                'Ikon centang hijau menunjukkan bilangan termasuk kategori tersebut',
                'Ikon silang merah menunjukkan bilangan tidak termasuk kategori tersebut',
                'Tekan ikon "X" pada kolom input untuk menghapus input'
              ],
              Icons.calculate,
            ),
            _buildFeatureSection(
              'Aplikasi Stopwatch',
              'Cara Menggunakan Stopwatch:',
              [
                'Tekan tombol dengan ikon "play" untuk memulai stopwatch',
                'Tekan tombol dengan ikon "pause" untuk menghentikan stopwatch',
                'Tekan tombol dengan ikon "refresh" untuk mengatur ulang stopwatch ke 00:00:00',
                'Gunakan tombol dengan ikon "flag" saat stopwatch berjalan untuk mencatat waktu putaran (lap)',
                'Waktu putaran akan ditampilkan di bagian bawah layar',
                'Waktu akan tetap berjalan meskipun aplikasi berada di background'
              ],
              Icons.timer,
            ),
            _buildFeatureSection(
              'Tracking LBS',
              'Cara Menggunakan Fitur Tracking LBS:',
              [
                'Izinkan aplikasi mengakses lokasi Anda saat diminta',
                'Tunggu aplikasi mendapatkan lokasi Anda saat ini',
                'Lihat posisi Anda yang ditandai pada peta yang ditampilkan',
                'Gunakan fitur zoom dan pan untuk menjelajahi peta',
                'Lokasi Anda akan diperbarui secara otomatis'
              ],
              Icons.location_on,
            ),
            _buildFeatureSection(
              'Saran Website',
              'Cara Menggunakan Fitur Saran Website:',
              [
                'Pilih kategori website dari dropdown menu',
                'Scroll halaman untuk melihat daftar situs yang direkomendasikan',
                'Tiap situs memiliki ikon, deskripsi, dan URL',
                'Klik tombol browser untuk membuka situs di browser eksternal',
                'Tambahkan situs ke favorit dengan menekan ikon hati',
                'Untuk melihat favorit, pilih kategori "Favorites" pada dropdown'
              ],
              Icons.web,
            ),
            _buildFeatureSection(
              'Fitur Bantuan Aplikasi',
              'Cara Menggunakan Fitur Bantuan:',
              [
                'Akses halaman ini melalui menu navigasi bawah dengan ikon buku',
                'Scroll halaman untuk melihat panduan penggunaan semua fitur',
                'Setiap bagian menjelaskan cara menggunakan fitur tertentu',
                'Ikuti langkah-langkah yang dijelaskan untuk menggunakan fitur dengan optimal'
              ],
              Icons.help,
            ),
            _buildFeatureSection(
              'Daftar Anggota',
              'Cara Mengakses Daftar Anggota:',
              [
                'Klik ikon "Anggota" pada menu navigasi bawah (ikon person)',
                'Lihat informasi tentang anggota tim pengembang aplikasi',
                'Setiap anggota ditampilkan dengan foto profil, nama, dan NIM',
                'Scroll untuk melihat semua anggota tim'
              ],
              Icons.people,
            ),
            _buildFeatureSection(
              'Logout',
              'Cara Logout dari Aplikasi:',
              [
                'Klik ikon logout di pojok kanan atas aplikasi',
                'Konfirmasi logout pada dialog yang muncul',
                'Pilih "Cancel" untuk membatalkan atau "Logout" untuk melanjutkan',
                'Sesi login Anda akan berakhir dan Anda akan diarahkan ke halaman login'
              ],
              Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  _buildFeatureSection(
      String title, String subtitle, List<String> steps, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
