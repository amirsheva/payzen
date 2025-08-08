import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payzen/screens/login_screen.dart';
import 'package:payzen/screens/quick_login_screen.dart';
import 'package:payzen/screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // تعریف پالت رنگی جدید با الهام از Qapital
    const backgroundColor = Color(0xFFFFFFFF); // پس‌زمینه سفید و تمیز
    final primaryColor = Colors.blue.shade700; // آبی پررنگ‌تر برای تاکید
    const textColor = Color(0xFF333333);
    const subtitleColor = Color(0xFF757575);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // بخش بصری اصلی با طراحی جدید
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wallet_rounded,
                  size: 60,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 40),
              // تایپوگرافی جدید و مدرن
              Text(
                "Manage your debts with ease",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "PayZen helps you track and manage your installments simply and beautifully.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: subtitleColor,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),
              // دکمه‌های جدید در پایین صفحه
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (kDebugMode)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const QuickLoginScreen()));
                  },
                  child: const Text('Quick Login (Debug)'),
                ),
              const SizedBox(height: 24),
              Text(
                "© 2025 Mania Group. All rights reserved.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
