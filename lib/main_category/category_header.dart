// 카테고리 가로 스크롤 선택 목록(라면/음료/간식...) 위젯입니다.
// 카테고리 화면용(CategoryPicker)과 홈 화면용(HomeCategoryStrip) 두 가지 디자인을 제공하며,
// 두 위젯 모두 같은 카테고리 목록(category_catalog.dart)을 사용합니다.

import 'package:flutter/material.dart';

import 'category_catalog.dart';

/// 카테고리 화면(라면/음료 화면 등) 상단에서 쓰는 카테고리 선택 목록.
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

/// 홈 화면(메인 홈, 비회원 홈, 검색 결과 화면)에서 쓰는 카테고리 선택 목록.
/// 항목은 [CategoryPicker]와 같지만, 디자인이 홈 화면에 맞춰 조금 다르다.
class HomeCategoryStrip extends StatelessWidget {
  const HomeCategoryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
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
                  children: [
                    Expanded(
                      child: Image.asset(
                        category.imageAsset,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    Text(
                      category.label,
                      style: const TextStyle(fontSize: 12),
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
