import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';

class ChallengeTab extends StatefulWidget {
  const ChallengeTab({super.key});

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab> {
  int _activeSubTab = 0; // 0: Aktif, 1: Tersedia, 2: Selesai
  final List<String> _subTabs = ['Aktif', 'Tersedia', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Header
            const Padding(
              padding: EdgeInsets.only(top: 24.0, left: 20, right: 20, bottom: 8),
              child: Text(
                'Challenge',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
            
            // Sub-Tab Selector Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Row(
                children: List.generate(_subTabs.length, (index) {
                  final isSelected = index == _activeSubTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeSubTab = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.mintGreen : AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _subTabs[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),

            // Tab Content
            Expanded(
              child: IndexedStack(
                index: _activeSubTab,
                children: [
                  _buildAktifTab(appState),
                  _buildTersediaTab(appState),
                  _buildSelesaiTab(appState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 1: Joined/Active Challenges
  Widget _buildAktifTab(AppState state) {
    final joined = state.joinedChallenges;
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Featured Challenge Card (Pilah 10 kg)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.secondaryGreen,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Challenge Unggulan',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Pilah 10 kg Minggu Ini',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Outfit'),
              ),
              const SizedBox(height: 4),
              const Text(
                '128 orang bergabung • Berakhir dalam 2 hari',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 16),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 0.7,
                  color: AppTheme.mintGreen,
                  backgroundColor: Colors.white24,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Simulate progress to complete the challenge
                  state.progressChallenge('Pilah 10 kg Minggu Ini', 3);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anda menyumbangkan 3 kg sampah ke Challenge ini!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryGreen,
                ),
                child: const Text('Setor Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _shortcutCard(
                icon: Icons.emoji_events_outlined,
                title: 'lencana',
                subtitle: 'Koleksi',
                onTap: () => Navigator.pushNamed(context, '/badges'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _shortcutCard(
                icon: Icons.leaderboard_outlined,
                title: 'papan peringkat',
                subtitle: 'Global',
                onTap: () => Navigator.pushNamed(context, '/leaderboard'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // List of Active joined challenges
        const Text(
          'Tantangan Berjalan',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 15),
        ),
        const SizedBox(height: 12),
        if (joined.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Tidak ada tantangan aktif.', style: TextStyle(color: AppTheme.textLight))),
          )
        else
          ...joined.map((challenge) => _challengeRow(challenge, state)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _shortcutCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.mintGreen, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _challengeRow(ChallengeItem challenge, AppState state) {
    final fraction = challenge.currentProgress / challenge.totalGoal;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circular Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: fraction,
                    strokeWidth: 4,
                    color: AppTheme.mintGreen,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
                Text(
                  '${challenge.currentProgress}/${challenge.totalGoal}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryGreen),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    challenge.description,
                    style: const TextStyle(color: AppTheme.textLight, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${challenge.duration} • +${challenge.rewardPoints} pts',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.mintGreen, fontSize: 11),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.primaryGreen),
              onPressed: () {
                state.progressChallenge(challenge.title, 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Tab 2: Available/Tersedia Challenges to join
  Widget _buildTersediaTab(AppState state) {
    final available = state.availableChallenges;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'Tantangan Tersedia',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 15),
        ),
        const SizedBox(height: 12),
        if (available.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Semua tantangan telah diikuti!', style: TextStyle(color: AppTheme.textLight))),
          )
        else
          ...available.map((challenge) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.lightMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.rocket_launch_rounded, color: AppTheme.mintGreen, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            challenge.description,
                            style: const TextStyle(color: AppTheme.textLight, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${challenge.duration} • +${challenge.rewardPoints} pts',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.mintGreen, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        state.joinChallenge(challenge.title);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Berhasil bergabung dalam challenge: ${challenge.title}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Ikut', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  // Tab 3: Completed/Selesai Challenges
  Widget _buildSelesaiTab(AppState state) {
    final completed = state.completedChallenges;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'Tantangan Selesai',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 15),
        ),
        const SizedBox(height: 12),
        if (completed.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Belum ada tantangan yang diselesaikan.', style: TextStyle(color: AppTheme.textLight))),
          )
        else
          ...completed.map((challenge) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.white.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF5F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            'Selesai • Mendapat +${challenge.rewardPoints} pts',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
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
}
