import 'package:flutter/material.dart';
import 'package:good_place/features/auth/firebase/authService.dart';
import 'package:good_place/features/auth/pages/welcome_page.dart';
import 'package:good_place/features/home/pages/home_page.dart';
import 'package:good_place/logger.dart';

/// Kullanıcı giriş yapmışsa AnaSayfaya , yapmamışsa [WelcomePage]'e gönder.
class AuthManager extends StatelessWidget {
  static const routeName = "authmanager";

  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const WelcomePage();
          }
        });
  }
}
