import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final badgesList = appState.badges;
    final totalBadges = badgesList.length;
    final unlockedCount = appState.unlockedBadgesCount;
    final progressPercent = totalBadges > 0 ? unlockedCount / totalBadges : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Badges',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Collection Progress Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.mintGreen,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.mintGreen.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Collection Progress',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Keep collecting badges!',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$unlockedCount/$totalBadges',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(
                            '${(progressPercent * 100).toInt()}% complete',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      color: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            
            // Grid of Badges
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.82,
                ),
                itemCount: totalBadges,
                itemBuilder: (context, index) {
                  final badge = badgesList[index];
                  final fraction = badge.currentProgress / badge.totalGoal;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // Tag (DAY, WEEK, MONTH)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPeriodColor(badge.period),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badge.period,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Badge Icon (Crown representation)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: badge.isUnlocked ? AppTheme.lightMint : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.emoji_events_rounded,
                            color: badge.isUnlocked ? AppTheme.mintGreen : Colors.grey.shade400,
                            size: 32,
                          ),
                        ),
                        const Spacer(),
                        // Title
                        Text(
                          badge.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: badge.isUnlocked ? AppTheme.primaryGreen : AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Progress description
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${badge.currentProgress}/${badge.totalGoal}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badge.isUnlocked ? AppTheme.primaryGreen : AppTheme.textLight,
                              ),
                            ),
                            Text(
                              '${(fraction * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badge.isUnlocked ? AppTheme.mintGreen : AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Small Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fraction,
                            color: badge.isUnlocked ? AppTheme.mintGreen : Colors.grey.shade300,
                            backgroundColor: Colors.grey.shade100,
                            minHeight: 5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPeriodColor(String period) {
    switch (period) {
      case 'DAY':
        return Colors.blue.shade400;
      case 'WEEK':
        return AppTheme.mintGreen;
      case 'MONTH':
        return AppTheme.accentGold;
      default:
        return Colors.grey;
    }
  }
}
