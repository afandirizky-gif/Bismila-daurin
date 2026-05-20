import 'package:flutter/material.dart';
import '../../theme.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'Apa itu Tunas?',
      'a': 'Tunas (atau DAURIN) adalah aplikasi pengelolaan sampah daur ulang berbasis mobile yang membantu masyarakat memilah sampah dengan bantuan AI, menyetorkannya ke drop point atau meminta penjemputan, dan mendapatkan imbalan poin yang dapat ditukar dengan saldo e-wallet.'
    },
    {
      'q': 'Bagaimana cara mendapatkan poin?',
      'a': 'Anda mendapatkan poin dengan memilah sampah Anda dan menyetorkannya melalui aplikasi. Pindai sampah menggunakan pemindai AI kami untuk memvalidasi jenis sampah, lalu bawa ke drop point terdekat atau jadwalkan kurir penjemputan untuk menimbangnya.'
    },
    {
      'q': 'Dimana lokasi drop point terdekat?',
      'a': 'Buka tab Deposit dan pilih Drop Point. Anda akan melihat peta interaktif yang menunjukkan semua stasiun penampungan daur ulang terdekat beserta status operasional (Buka/Tutup) dan jaraknya dari tempat Anda.'
    },
    {
      'q': 'Jenis sampah apa saja yang diterima?',
      'a': 'Kami menerima berbagai jenis sampah anorganik termasuk Botol Plastik PET, Kertas & Karton, Kaleng Logam (Aluminium & Besi), Kaca, dan sampah B3 rumah tangga tertentu. Silakan periksa panduan jenis sampah di tab Deposit.'
    },
    {
      'q': 'Bagaimana cara menukar poin dengan reward?',
      'a': 'Buka tab Reward, masukkan jumlah poin yang ingin Anda tukarkan, lalu pilih metode pencairan saldo e-wallet yang Anda inginkan (GoPay, OVO, atau DANA). Klik Tukar dan saldo akan masuk secara instan.'
    },
    {
      'q': 'Apakah ada biaya untuk menggunakan Tunas?',
      'a': 'Tidak, aplikasi Tunas 100% gratis untuk diunduh dan digunakan. Tidak ada biaya pendaftaran, biaya transaksi penukaran koin, atau biaya penjemputan sampah daur ulang.'
    },
    {
      'q': 'Bagaimana cara mengajak teman?',
      'a': 'Di tab Reward, pilih submenu "Tersedia" untuk melihat kode referral unik Anda (contoh: PUTRA24). Salin atau bagikan kode tersebut kepada teman Anda. Saat mereka mendaftar dan melakukan setoran pertama, Anda berdua akan mendapatkan bonus 200 poin!'
    },
    {
      'q': 'Apa itu badge dan bagaimana cara mendapatkannya?',
      'a': 'Badges adalah tanda pencapaian atas aksi ramah lingkungan Anda. Anda bisa membukanya dengan menyelesaikan tugas sehari-hari atau tantangan mingguan seperti "Bike to Work" atau "Zero Single-Use Straws". Buka halaman Badges dari profil Anda untuk melihat kemajuan.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: Column(
        children: [
          // Header Accent Area
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
            color: AppTheme.secondaryGreen,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Bantuan & FAQ',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance back button
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kami siap membantu Anda',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 20),
                // Tabs
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppTheme.mintGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: const [
                      Tab(text: 'FAQ'),
                      Tab(text: 'Hubungi Kami'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // FAQ Tab content
                _buildFaqList(),
                // Contact Tab content
                _buildContactChannels(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Pertanyaan Umum',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        ..._faqs.map((faq) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.help_outline_rounded, color: AppTheme.mintGreen),
                title: Text(
                  faq['q']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.textDark,
                  ),
                ),
                iconColor: AppTheme.primaryGreen,
                collapsedIconColor: AppTheme.textLight,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 56.0, right: 16.0, bottom: 16.0),
                    child: Text(
                      faq['a']!,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildContactChannels() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Hubungi Tim Kami',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tidak menemukan jawaban yang Anda cari? Tim support kami siap membantu Anda.',
          style: TextStyle(color: AppTheme.textLight, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 24),
        
        // Email Tile
        _contactCard(
          icon: Icons.mail_outline_rounded,
          iconColor: Colors.red.shade400,
          title: 'Email',
          value: 'support@tunas.id',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        // WhatsApp Tile
        _contactCard(
          icon: Icons.phone_android_rounded,
          iconColor: Colors.green,
          title: 'WhatsApp',
          value: '+62 812–3456–7890',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        // Live Chat Tile
        _contactCard(
          icon: Icons.forum_outlined,
          iconColor: Colors.blue,
          title: 'Live Chat',
          value: 'Chat dengan kami',
          onTap: () {},
        ),
        const SizedBox(height: 24),

        // Quick Tips
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF5F1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.mintGreen.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.accentGold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Tips Cepat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _tipRow('Respons email biasanya dalam 24 jam'),
              _tipRow('Live chat tersedia 08:00 - 20:00 WIB'),
              _tipRow('Siapkan screenshot untuk laporan bug'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryGreen),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.textLight),
        onTap: onTap,
      ),
    );
  }

  Widget _tipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.mintGreen)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppTheme.textDark, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
