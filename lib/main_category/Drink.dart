import 'package:flutter/material.dart';

class DrinkScreen extends StatelessWidget {
  const DrinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 열의 수
        children: List.generate(4, (index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_cafe, size: 48), // 아이콘 추가
                const SizedBox(height: 8), // 간격 조정
                Text(
                  'Drink $index', // 작은 텍스트 추가
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
