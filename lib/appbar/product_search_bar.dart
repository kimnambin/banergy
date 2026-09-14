// 앱바에 들어가는 상품 검색창 위젯입니다.
// 검색 아이콘을 누르면 검색 결과 화면(SearchScreen)으로 이동합니다.
// 예전에는 이 위젯이 Home_SearchWidget/SearchWidget 두 파일에 똑같이 복사되어 있었습니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/search.dart';

class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({super.key});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
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
            SearchScreen(searchText: _searchController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width,
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
            contentPadding: const EdgeInsets.only(left: 30, bottom: 13),
            suffixIcon: IconButton(
              onPressed: _openSearchResults,
              icon: const Icon(Icons.search, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
