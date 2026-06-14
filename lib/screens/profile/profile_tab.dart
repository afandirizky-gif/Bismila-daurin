import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Consumer<AppState>(
    builder: (context, appState, child) {
    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Card (Profile details & Level progress)
            Container(
              padding: const EdgeInsets.only(
                  top: 60, bottom: 28, left: 24, right: 24),
              decoration: const BoxDecoration(
                color: AppTheme.mintGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // Avatar with level badge indicator
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          image: DecorationImage(
          image: appState.profileImage != null 
              ? FileImage(appState.profileImage!) as ImageProvider 
              : const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?'),
          fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Username
                  Text(
                    appState.userName.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Eco title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Eco Warrior • Level ${appState.userLevel}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Level progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: appState.levelProgress,
                      color: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      minHeight: 8,
                         ),
                        ),
                      ],
                    ),
                  ),
               
          

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Core Stats Row (Poin, Streak, Stor)
                  Row(
                    children: [
                      _statCard(context, '${appState.totalPoints}', 'Poin',
                          Icons.emoji_events_rounded, Colors.teal),
                      const SizedBox(width: 10),
                      _statCard(
                          context,
                          '${appState.streakCount}',
                          'hari streak',
                          Icons.local_fire_department_rounded,
                          AppTheme.accentGold),
                      const SizedBox(width: 10),
                      _statCard(
                          context,
                          '${appState.totalDepositsCount}',
                          'total stor',
                          Icons.inventory_2_rounded,
                          AppTheme.primaryGreen),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Secondary Impact Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CO2 Bulan Ini',
                                  style: TextStyle(
                                      color: AppTheme.textLight, fontSize: 11)),
                              const SizedBox(height: 6),
                              Text('${appState.co2Prevented} kg dicegah',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Jumlah Setor',
                                  style: TextStyle(
                                      color: AppTheme.textLight, fontSize: 11)),
                              const SizedBox(height: 6),
                              Text(
                                  '${appState.depositCountThisMonth}x bulan ini',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Highlights (4 pohon, 230L air, 18kwh saved)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _highlightPill('4 pohon', Icons.forest_rounded),
                      _highlightPill('230L air', Icons.water_drop_rounded),
                      _highlightPill('18kwh', Icons.bolt_rounded),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Profile/Settings Navigation List
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _settingsTile(context, Icons.person_outline_rounded,
                            'Data User', () {}),
                        _settingsTile(context, Icons.history_rounded,
                            'Riwayat Stor Sampah', () {}),
                        _settingsTile(context, Icons.analytics_outlined,
                            'Statistik Dampak Lingkungan', () {}),
                        _settingsTile(context, Icons.notifications_none_rounded,
                            'Notifikasi', () {}),
                        _settingsTile(context, Icons.settings_outlined,
                            'Settings', () {}),
                        _settingsTile(context, Icons.help_outline_rounded,
                            'Bantuan & FAQ', () {
                          Navigator.pushNamed(context, '/faq');
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/welcome', (route) => false);
                    },
                    icon: const Icon(Icons.logout_rounded,
                        color: AppTheme.primaryGreen),
                    label: const Text('Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppTheme.primaryGreen, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}

  Widget _statCard(BuildContext context, String value, String label,
      IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.primaryGreen)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppTheme.textLight, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _highlightPill(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.creamBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppTheme.textLight),
      onTap: onTap,
    );
  }
}
