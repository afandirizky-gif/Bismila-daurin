import 'package:flutter/material.dart';
import '../../theme.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Pilah Sampah\nLebih Mudah',
      'desc': 'Scan sampahmu dengan AI dan langsung tahu, cara penanganannya — tanpa bingung lagi.',
      'icon': Icons.qr_code_scanner_rounded,
      'color': AppTheme.mintGreen,
      'drawWidget': _RecycleBinGraphic(),
    },
    {
      'title': 'Dapatkan E - Wallet\nRewards',
      'desc': 'Kumpulkan poin dari setiap sampah yang kamu setorkan dan tukarkan dengan saldo e-wallet favoritmu seperti GoPay, OVO, dan DANA.',
      'icon': Icons.account_balance_wallet_rounded,
      'color': AppTheme.accentGold,
      'drawWidget': _WalletGraphic(),
    },
    {
      'title': 'Lihat Dampakmu\nuntuk Bumi',
      'desc': 'Pantau berapa kg CO₂ yang kamu cegah setiap bulan. Aksi kecilmu nyata adanya.',
      'icon': Icons.public_rounded,
      'color': AppTheme.primaryGreen,
      'drawWidget': _EarthGraphic(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top action bar (Page X/3 & Lewati)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_currentIndex + 1}/3',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/main_frame'),
                    child: const Text(
                      'Lewati',
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Onboarding slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dynamic Graphic Container
                        Expanded(
                          child: Center(
                            child: data['drawWidget'] as Widget,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        Text(
                          data['title'] as String,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          data['desc'] as String,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textLight,
                                height: 1.6,
                                fontSize: 15,
                              ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Pagination Dots & Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isSelected = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8.0,
                        width: isSelected ? 24.0 : 8.0,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.mintGreen.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/main_frame');
                        }
                      },
                      child: Text(_currentIndex == 2 ? 'Mulai Sekarang' : 'Lanjut'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Graphic component for page 1: Recycling category bins
class _RecycleBinGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_rounded, color: AppTheme.mintGreen, size: 28),
              const SizedBox(width: 8),
              Text(
                'AI Scanner',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.creamBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.mintGreen.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _binRow('Mixed Paper & Card', AppTheme.primaryGreen),
                  _binRow('Food & Drink Cans', Colors.grey),
                  _binRow('Mixed Glass & Bottles', AppTheme.mintGreen),
                  _binRow('Plastic Packaging', AppTheme.accentGold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _binRow(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.recycling_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// Graphic component for page 2: E-Wallet cards and transactions
class _WalletGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Card
          Positioned(
            top: 20,
            child: Transform.rotate(
              angle: -0.15,
              child: Container(
                width: 190,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OVO Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Spacer(),
                    Text('Rp 50.000', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          // Foreground Card
          Positioned(
            bottom: 30,
            child: Transform.rotate(
              angle: 0.08,
              child: Container(
                width: 200,
                height: 125,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryGreen, AppTheme.mintGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('DAURIN Points', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Icon(Icons.eco_rounded, color: AppTheme.accentGold, size: 20),
                      ],
                    ),
                    const Spacer(),
                    const Text('2,450 pts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                  ],
                ),
              ),
            ),
          ),
          // Floating Coin
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppTheme.accentGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

// Graphic component for page 3: Hands shielding the Earth
class _EarthGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft circles
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.lightMint.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.lightMint,
              shape: BoxShape.circle,
            ),
          ),
          // Earth
          Icon(Icons.public_rounded, color: AppTheme.primaryGreen.withOpacity(0.85), size: 100),
          // Shielding Leaf
          Positioned(
            bottom: 40,
            right: 40,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppTheme.mintGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
