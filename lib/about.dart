import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan Aplikasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                'Masukkan username dan password yang valid',
                'Klik tombol "Login" untuk masuk ke aplikasi',
                'Jika lupa password, gunakan fitur "Lupa Password"',
                'Aplikasi akan menyimpan sesi login Anda'
              ],
              Icons.login,
            ),
            _buildFeatureSection(
              'Aplikasi Stopwatch',
              'Cara Menggunakan Stopwatch:',
              [
                'Tekan tombol "Start" untuk memulai stopwatch',
                'Tekan tombol "Stop" untuk menghentikan stopwatch',
                'Tekan tombol "Reset" untuk mengatur ulang stopwatch ke 00:00:00',
                'Gunakan tombol "Lap" untuk mencatat waktu putaran'
              ],
              Icons.timer,
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
              'Tracking LBS',
              'Cara Menggunakan Fitur Tracking LBS:',
              [
                'Izinkan aplikasi mengakses lokasi Anda',
                'Klik tombol "Mulai Tracking" untuk mulai melacak posisi',
                'Lihat lokasi Anda pada peta yang ditampilkan',
                'Gunakan tombol "Refresh" untuk memperbarui lokasi',
                'Klik tombol "Berhenti Tracking" untuk menghentikan pelacakan'
              ],
              Icons.location_on,
            ),
            _buildFeatureSection(
              'Konversi Waktu',
              'Cara Menggunakan Fitur Konversi Waktu:',
              [
                'Masukkan nilai tahun yang ingin dikonversi',
                'Klik "Konversi" untuk melihat hasil konversi',
                'Hasil akan menampilkan konversi ke jam, menit, dan detik',
                'Gunakan tombol "Reset" untuk mengosongkan input'
              ],
              Icons.access_time,
            ),
            _buildFeatureSection(
              'Daftar Situs Rekomendasi',
              'Cara Menggunakan Fitur Daftar Situs:',
              [
                'Scroll halaman untuk melihat daftar situs rekomendasi',
                'Tiap situs memiliki gambar, deskripsi, dan link',
                'Klik pada gambar atau tombol "Kunjungi" untuk membuka situs',
                'Tambahkan situs ke favorit dengan menekan ikon bintang'
              ],
              Icons.web,
            ),
            _buildFeatureSection(
              'Favorit',
              'Cara Menggunakan Fitur Favorit:',
              [
                'Lihat daftar situs yang telah Anda tandai sebagai favorit',
                'Hapus situs dari favorit dengan menekan ikon bintang lagi',
                'Gunakan fitur pencarian untuk menemukan favorit tertentu'
              ],
              Icons.favorite,
            ),
            _buildFeatureSection(
              'Daftar Anggota',
              'Cara Mengakses Daftar Anggota:',
              [
                'Klik ikon "Anggota" pada menu navigasi bawah',
                'Lihat informasi tentang anggota tim pengembang aplikasi',
                'Scroll untuk melihat semua anggota tim'
              ],
              Icons.people,
            ),
            _buildFeatureSection(
              'Logout',
              'Cara Logout dari Aplikasi:',
              [
                'Klik ikon logout pada menu aplikasi',
                'Konfirmasi logout pada dialog yang muncul',
                'Sesi login Anda akan berakhir dan kembali ke halaman login'
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
