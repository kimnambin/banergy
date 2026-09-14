// 로그아웃 버튼이 있는 메뉴 화면입니다.

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('authToken');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FirstApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('메뉴 페이지 내용이 나타납니다.'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
