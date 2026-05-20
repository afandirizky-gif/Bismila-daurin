import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedScope = 1; // 0: RT, 1: Provinsi, 2: Kota, 3: Negara
  int _selectedPeriod = 1; // 0: Minggu, 1: Bulan, 2: Tahun

  final List<String> _scopes = ['RT', 'Provinsi', 'Kota', 'Negara'];
  final List<String> _periods = ['Minggu', 'Bulan', 'Tahun'];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final users = appState.leaderboardUsers;

    // Podium Users
    final first = users.firstWhere((u) => u.rank == 1);
    final second = users.firstWhere((u) => u.rank == 2);
    final third = users.firstWhere((u) => u.rank == 3);

    // List Users (ranks 4-10)
    final scrollUsers = users.where((u) => u.rank > 3).toList();

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scope Tabs (RT, Provinsi, Kota, Negara)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_scopes.length, (index) {
                  final isSelected = index == _selectedScope;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedScope = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        _scopes[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Period Tabs (Minggu, Bulan, Tahun)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_periods.length, (index) {
                  final isSelected = index == _selectedPeriod;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        _periods[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),

            // Main Content Area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  // Progress Card Reminder (similar to Page 30)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppTheme.accentGold, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kumpulkan lencana untuk naik ke podium!',
                            style: TextStyle(fontSize: 12, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${appState.unlockedBadgesCount}/${appState.badges.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Top Champions Podium Area
                  const Center(
                    child: Text(
                      '✨ Top Champions ✨',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Chip(
                      label: Text(appState.userDomisili),
                      labelStyle: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 11),
                      backgroundColor: AppTheme.lightMint,
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3 Column Podium UI
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // #2 Second Place
                      _podiumColumn(second, 100, Colors.grey.shade300, '2', const Offset(-4, 0)),
                      const SizedBox(width: 12),
                      // #1 First Place
                      _podiumColumn(first, 125, AppTheme.accentGold, '1', const Offset(0, -6)),
                      const SizedBox(width: 12),
                      // #3 Third Place
                      _podiumColumn(third, 85, Colors.orange.shade300, '3', const Offset(4, 0)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // List Rankings Header
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rankings 4-10',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryGreen),
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 8),
                          SizedBox(width: 4),
                          Text('Live', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rankings List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: scrollUsers.length,
                    itemBuilder: (context, index) {
                      final user = scrollUsers[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '#${user.rank}',
                                style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.mintGreen, fontSize: 15),
                              ),
                              const SizedBox(width: 12),
                              const CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80'),
                              ),
                            ],
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.local_fire_department_rounded, color: AppTheme.accentGold, size: 14),
                              const SizedBox(width: 4),
                              Text('${user.streak} day streak', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${user.points}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryGreen),
                                  ),
                                  Text(
                                    user.change,
                                    style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _podiumColumn(LeaderboardUser user, double height, Color medalColor, String rankStr, Offset offset) {
    return Column(
      children: [
        // User Avatar with Badge Number
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: medalColor, width: 3),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: medalColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                rankStr,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Name
        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
        const SizedBox(height: 2),
        // Score
        Text('${user.points} pts', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.mintGreen)),
        const SizedBox(height: 4),
        // Podium block
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, -2),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rank $rankStr',
                style: TextStyle(fontWeight: FontWeight.w900, color: medalColor.withOpacity(0.9), fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: AppTheme.accentGold, size: 14),
                  Text('${user.streak}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
