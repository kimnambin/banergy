import 'package:flutter/material.dart';

class FastfoodScreen extends StatelessWidget {
  const FastfoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast food'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 열의 수
        children: List.generate(4, (index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fastfood, size: 48), // 아이콘 추가
                const SizedBox(height: 8), // 간격 조정
                Text(
                  'Fast Food $index', // 작은 텍스트 추가
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
