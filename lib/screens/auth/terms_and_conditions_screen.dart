import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Syarat & Ketentuan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHeader("Pemilahan & Edukasi"),
            _buildItem("Panduan Pilah Sampah",
                "Pengguna mendapatkan panduan visual dan interaktif untuk memilah sampah organik, anorganik, dan B3 tanpa harus membaca teks panjang."),
            _buildItem("Fitur Edukasi",
                "Aplikasi menyajikan data emisi CH4 dari TPA secara sederhana dan relevan untuk meningkatkan kesadaran dampak iklim."),
            _buildItem("Identifikasi AI",
                "Teknologi pengenalan gambar membantu mengurangi kesalahan klasifikasi sampah di tingkat rumah tangga."),
            _buildItem("Dashboard Perkembangan",
                "Pengguna dapat memantau riwayat pemilahan dan peningkatan akurasi dari waktu ke waktu."),
            Divider(),
            _buildHeader("Akses & Logistik"),
            _buildItem("Drop Point Real-time",
                "Peta lokasi bank sampah dan waste station terupdate secara real-time untuk memudahkan akses pengguna."),
            _buildItem("Layanan Antar Sampah",
                "Pengguna dapat menjadwalkan pickup sampah terpilah langsung dari aplikasi dengan menentukan tanggal, jenis sampah, dan titik jemput."),
            _buildItem("Filter Kategori",
                "Sistem memungkinkan penyaringan fasilitas berdasarkan jenis sampah (organik, plastik, B3, dll) agar sesuai dengan kapasitas penerimaan material."),
            _buildItem("Dashboard Logistik",
                "RT/RW atau komunitas dapat memantau total volume sampah, frekuensi pickup, dan potensi pengurangan emisi untuk evaluasi."),
            Divider(),
            _buildHeader("Insentif & Dampak Iklim"),
            _buildItem("Sistem Reward Digital",
                "Sampah terpilah yang dikirim atau dijemput akan menghasilkan poin yang dapat dicairkan ke e-wallet seperti OVO, GoPay, atau DANA."),
            _buildItem("Dashboard Dampak Pribadi",
                "Pengguna dapat melihat estimasi total emisi CH4 yang dicegah serta leaderboard komunitas untuk mendorong keterlibatan sosial."),
            _buildItem("Laporan Terverifikasi",
                "Pengguna menerima ringkasan kontribusi periodik mengenai total sampah terpilah dan nilai ekonomi yang dihasilkan."),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
    );
  }

  Widget _buildItem(String subTitle, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subTitle, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(content,
              style: TextStyle(fontSize: 14, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
