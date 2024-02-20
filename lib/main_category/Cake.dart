import 'package:flutter/material.dart';

class CakeScreen extends StatelessWidget {
  const CakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cake'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 열의 수
        children: List.generate(4, (index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cake, size: 48), // 아이콘 추가
                const SizedBox(height: 8), // 간격 조정
                Text(
                  'Cake $index', // 작은 텍스트 추가
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
