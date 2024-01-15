import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';

class CodeScreen extends StatelessWidget {
  final String resultCode;

  CodeScreen({required this.resultCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MypageApp()),
            );
          },
        ),
      ),
      body: Center(
        child: Text(': ${resultCode ?? "스캔된 정보 없음"}'),
      ),
    );
  }
}
