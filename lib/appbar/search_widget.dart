// appbar 검색하는 부분

import 'package:flutter/material.dart';
//import 'package:flutter_banergy/appbar/menu.dart';
import 'package:flutter_banergy/appbar/search.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/mypage/mypage_filtering_allergies.dart';
import 'package:flutter_banergy/product/product_detail.dart';
//import 'package:flutter_banergy/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: must_be_immutable
class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  List<Product> likedProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch); // 검색어가 변경될 때마다 검색
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch); // 검색어 변경시 끝
    _searchController.dispose();
    super.dispose();
  }

  void _showLikedProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LikedProductsWidget(likedProducts: likedProducts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
            [
              IconButton(
                icon: Image.asset(
                  'assets/images/filter.png',
                  width: 24.0,
                  height: 24.0,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilteringPage(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check_box),
                onPressed: () => _showLikedProducts(context),
              ),
            ];
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8, horizontal: 0), // 좌우 여백 추가
          child: Row(
            children: [
              Expanded(
                // MediaQuery 대신 Expanded 사용
                child: Container(
                  height: 35, // 고정 높이 설정
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    // 중앙 정렬을 위해 Center 위젯 추가
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'PretendardBold',
                      ),
                      decoration: InputDecoration(
                        hintText: '궁금했던 상품 정보를 검색해보세요',
                        border: InputBorder.none, // 선 없애기
                        contentPadding: const EdgeInsets.only(
                            left: 30, bottom: 13), // 여기서 bottom 값을 음수로 조정

                        suffixIcon: IconButton(
                          onPressed: _onSearchPressed,
                          icon: const Icon(
                            Icons.search,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /*IconButton(
                onPressed: _onMenuPressed,
                icon: const Icon(Icons.menu),
              ),*/
              )
            ],
          ),
        ),
      ),
      body: _isSearching ? _buildSearchResults() : _buildProductList(),
    );
  }

  void _onSearchPressed() {
    // 검색 실행
    _performSearch();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          searchText: _searchController.text,
        ),
      ),
    );
  }

//여기가 검색창 밑에 뜨게 해주는 부분
  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_products[index]['name']),
        );
      },
    );
  }

// 검색 결과부분 (여기는 밑에 뜨는 거 )
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_products[index]['name']),
        );
      },
    );
  }

//여기가 검색 결과
  void _performSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _products.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final response = await http.get(Uri.parse('$baseUrl:8000/?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _products = data
            .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
            .toList();
        _isSearching = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }
}

// 상품 클릭 시 새로운창에서 상품 정보를 표시하는 함수
void _handleProductClick(BuildContext context, Product product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => pdScreen(product: product),
    ),
  );
}
