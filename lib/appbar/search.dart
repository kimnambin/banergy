import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 검색'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '상품 검색',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _performSearch(_searchController.text);
                },
                child: const Text('검색'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_products[index]['name']),
                  onTap: () {
                    _showProductDetail(_products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _products = data
            .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
            .toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _showProductDetail(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product['name']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('카테고리: ${product['kategorie']}'),
              Text('바코드: ${product['barcode']}'),
              Text('정면 이미지: ${product['frontproduct']}'),
              Text('후면 이미지: ${product['backproduct']}'),
              Text('알레르기 식품: ${product['allergens']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
