import 'package:flutter/material.dart';

class CodeScreen extends StatelessWidget {
  final String resultCode;

  CodeScreen({required this.resultCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 정보'),
      ),
      body: Center(
        child: Text(': ${resultCode ?? "스캔된 정보 없음"}'),
      ),
    );
  }
}
