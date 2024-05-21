// 카테고리내에서 검색할 수 있는 위젯을 만들어서 붙이자..!

import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  bool _isSearching = false;
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
