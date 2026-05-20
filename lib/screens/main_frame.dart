import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_tab.dart';
import 'profile/profile_tab.dart';
import 'challenge/challenge_tab.dart';
import 'rewards/rewards_tab.dart';
import 'deposit/deposit_flow_screens.dart';

class MainFrame extends StatefulWidget {
  final int initialTab;

  const MainFrame({
    super.key,
    this.initialTab = 2, // Default to Home
  });

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  // Navigation tabs list
  final List<Widget> _tabs = [
    const SetorSampahScreen(), // Deposit (Index 0)
    const ChallengeTab(),      // Challenge (Index 1)
    const HomeTab(),           // Home (Index 2)
    const RewardsTab(),        // Reward (Index 3)
    const ProfileTab(),        // Profile (Index 4)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.primaryGreen,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.recycling_rounded),
              label: 'Deposit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_rounded),
              label: 'Challenge',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded),
              label: 'Reward',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
