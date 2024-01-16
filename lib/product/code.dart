import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';

class CodeScreen extends StatelessWidget {
  final String resultCode;

  const CodeScreen({super.key, required this.resultCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          },
        ),
      ),
      body: Center(
        child: Text(': $resultCode'),
      ),
    );
  }
}
