import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/daurin_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/welcome'),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Logo
              const DaurinLogo(size: 150, fontSize: 36),
              const SizedBox(height: 32),
              // Slogan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Pilah sampah lebih mudah, dapat reward nyata, dan lihat dampakmu bagi bumi.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textDark,
                        height: 1.5,
                        fontSize: 16,
                      ),
                ),
              ),
              const Spacer(flex: 2),
              // Interactive Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap untuk melanjutkan',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                ],
              ),
              const Spacer(flex: 2),
              // Version code
              Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textLight.withOpacity(0.6),
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
