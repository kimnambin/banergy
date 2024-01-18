import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴'),
      ),
      body: const Center(
        child: Text('메뉴 페이지 내용이 나타납니다.'),
      ),
    );
  }
}
