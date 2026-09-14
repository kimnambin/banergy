// 카테고리 화면 상단에 보여주는 가로 스크롤 카테고리 선택 목록(라면/음료/간식...) 위젯입니다.

import 'package:flutter/material.dart';

import 'category_catalog.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        scrollDirection: Axis.horizontal,
        itemCount: kCategoryDefinitions.length,
        itemBuilder: (BuildContext context, int index) {
          final CategoryDefinition category = kCategoryDefinitions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: category.pageBuilder),
              );
            },
            child: SizedBox(
              width: 100,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      category.imageAsset,
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      category.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'PretendardBold',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
