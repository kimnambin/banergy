import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return const Center(
      child: CircularProgressIndicator(),
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
        await http.get(Uri.parse('http://127.0.0.1:5000/?query=$query'));
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
