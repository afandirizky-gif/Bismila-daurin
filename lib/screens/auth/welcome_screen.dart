import 'package:flutter/material.dart';
import '../../theme.dart';
import 'package:flutter/gestures.dart';
import 'terms_and_conditions_screen.dart';

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

              Center(
                child: Container(
                  height: 240,
                  width: 240,
                  decoration: BoxDecoration(
                    color: AppTheme.lightMint,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo-d.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Title Header
              Text(
                'Mulai Perjalanan\nHijau-mu',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 43,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                      fontFamily: 'Outfit',
                      letterSpacing: -1.0,
                    ),
              ),
              const SizedBox(height: 14),

              Text(
                'Pilah sampah lebih mudah, dapat reward nyata,\ndan lihat dampakmu bagi bumi',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      height: 1.5,
                      fontSize: 14,
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
                  side:
                      const BorderSide(color: AppTheme.primaryGreen, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Daftar Gratis',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      color: const Color.fromARGB(255, 26, 25, 25),
                      fontSize: 14),
                  children: [
                    TextSpan(text: "Dengan mendaftar, kamu menyetujui "),
                    TextSpan(
                      text: "Syarat & Ketentuan",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndConditionsScreen()),
                          );
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
