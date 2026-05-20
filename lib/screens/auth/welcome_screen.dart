import 'package:flutter/material.dart';
import '../../theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              
              // App Logo & Graphic Illustration
              Center(
                child: Container(
                  height: 240,
                  width: 240,
                  decoration: BoxDecoration(
                    color: AppTheme.lightMint,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.recycling_rounded,
                      color: AppTheme.primaryGreen,
                      size: 120,
                    ),
                  ),
                ),
              ),
              
              const Spacer(flex: 1),

              // Title Header
              Text(
                'Daurin',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                      fontFamily: 'Outfit',
                      letterSpacing: -1.0,
                    ),
              ),
              const SizedBox(height: 12),
              
              // Subtext
              Text(
                'Ubah Aksi Hijaumu Menjadi\nRewards Berharga',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textLight,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              
              const Spacer(flex: 2),

              // Sign In Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Masuk Ke Akun'),
              ),
              const SizedBox(height: 12),
              
              // Sign Up Button
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  side: const BorderSide(color: AppTheme.primaryGreen, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Daftar Gratis',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
