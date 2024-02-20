// appbar 검색하는 부분

import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/menu.dart';
import 'package:flutter_banergy/appbar/search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        title: Row(
          children: [
            const Text('밴러지'),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '검색',
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      onPressed: () {
                        // 검색 아이콘을 눌러서 검색 실행
                        _performSearch();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(
                                searchText: _searchController.text),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: _isSearching ? _buildSearchResults() : _buildProductList(),
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

    final response =
        await http.get(Uri.parse('http://10.55.4.107:8000/?query=$query'));
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
