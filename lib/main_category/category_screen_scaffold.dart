// 카테고리 화면 하나(예: 라면 화면, 음료 화면)의 공통 뼈대를 그려주는 위젯입니다.
// 검색창 + 카테고리 가로 목록 + 상품 그리드로 구성되며, 어떤 카테고리의 상품을 보여줄지만
// categoryQuery로 전달받습니다.

import 'package:flutter/material.dart';

import 'category_header.dart';
import 'category_search_screen.dart';
import 'product_grid_sliver.dart';

class CategoryScreenScaffold extends StatefulWidget {
  const CategoryScreenScaffold({super.key, required this.categoryQuery});

  /// 이 화면에서 보여줄 상품을 조회할 때 쓰는 카테고리 검색어 (예: '라면').
  final String categoryQuery;

  @override
  State<CategoryScreenScaffold> createState() =>
      _CategoryScreenScaffoldState();
}

class _CategoryScreenScaffoldState extends State<CategoryScreenScaffold> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearchResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategorySearchScreen(searchText: _searchController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 200.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontFamily: 'PretendardBold'),
                    decoration: InputDecoration(
                      hintText: '궁금했던 상품 정보를 검색해보세요',
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 15, bottom: 13),
                      suffixIcon: IconButton(
                        onPressed: _openSearchResults,
                        icon: const Icon(Icons.search, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              background: CategoryPicker(),
            ),
          ),
          ProductGridSliver(categoryQuery: widget.categoryQuery),
        ],
      ),
    );
  }
}
