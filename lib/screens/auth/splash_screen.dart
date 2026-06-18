import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Memberikan waktu sedikit agar animasi terlihat
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final userData = await AuthService.init();
    if (!mounted) return;
    
    if (userData != null) {
      Provider.of<AppState>(context, listen: false).setUserData(userData);
      Navigator.pushReplacementNamed(context, '/main_frame');
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SafeArea(
        child: Column(
            children: [
              const Spacer(flex: 3),
              Image.asset(
                'assets/logo_a.png',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Pilah sampah lebih mudah, dapat reward nyata, dan lihat dampakmu bagi bumi.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        height: 1.5,
                        fontSize: 14,
                      ),
                ),
              ),
              const SizedBox(height: 22),
              // Interactive Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap untuk melanjutkan',
                    style: TextStyle(
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                ],
              ),
              const Spacer(flex: 2),
              // Version code with underline
              Column(
                children: [
                  Text(
                    'v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textLight.withOpacity(0.6),
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 90,
                    height: 2,
                    color: const Color.fromARGB(255, 25, 18, 18).withOpacity(0.3),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
    );
  }
}
