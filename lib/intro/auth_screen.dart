import 'package:flutter/material.dart';
import 'package:flutter_banergy/intro/intro_page_a.dart';
import 'package:flutter_banergy/intro/intro_page_b.dart';
import 'package:flutter_banergy/intro/intro_page_c.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: [
          IntroPageA(_pageController),
          IntroPageB(_pageController),
          IntroPageC(_pageController),
        ],
      ),
    );
  }
}
