// 음료 카테고리 상품 목록 화면입니다.
// 실제 화면(검색창, 카테고리 목록, 상품 그리드)은 CategoryScreenScaffold가 그려주고,
// 이 파일은 "음료 카테고리를 보여준다"는 것만 지정합니다.

import 'package:flutter/material.dart';

import 'category_screen_scaffold.dart';

class DrinkScreen extends StatelessWidget {
  const DrinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryScreenScaffold(categoryQuery: '음료');
  }
}
