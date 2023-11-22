import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴'),
      ),
      body: Center(
        child: Text('메뉴 페이지 내용이 나타납니다.'),
      ),
    );
  }
}
