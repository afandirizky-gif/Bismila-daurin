import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/profile_setup_screen.dart';
import 'screens/onboarding/onboarding_screens.dart';
import 'screens/main_frame.dart';
import 'screens/profile/faq_screens.dart';
import 'screens/profile/badges_screen.dart';
import 'screens/challenge/leaderboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const DaurinApp(),
    ),
  );
}

class DaurinApp extends StatelessWidget {
  const DaurinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAURIN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/onboarding': (context) => const OnboardingScreens(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/otp': (context) => const OtpScreen(),
        '/profile_setup': (context) => const ProfileSetupScreen(),
        '/main_frame': (context) => const MainFrame(),
        '/faq': (context) => const FaqScreen(),
        '/badges': (context) => const BadgesScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}
