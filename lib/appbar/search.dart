import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _products = List.generate(100, (index) => 'Product $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 검색'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: '상품 검색',
            ),
            onChanged: (query) {
              // 검색어를 입력할 때 동작 추가
              _performSearch(query);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    // 검색 기능을 추가하여 검색 결과를 업데이트합니다.
    setState(() {
      _products =
          _products.where((product) => product.contains(query)).toList();
    });
  }
}
