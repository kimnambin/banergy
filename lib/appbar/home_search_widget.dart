import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/search.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/product/product_detail.dart';
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
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * 1.0, // 너비를 조정하여 적절히 맞춤
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          style: const TextStyle(
            fontFamily: 'PretendardBold',
          ),
          decoration: InputDecoration(
            hintText: '궁금했던 상품 정보를 검색해보세요',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(left: 30, bottom: 13),
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
    );
  }

  void _onSearchPressed() {
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

  void _performSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _products.clear();
      });
      return;
    }

    setState(() {});

    final response = await http.get(Uri.parse('$baseUrl:8000/?query=$query'));
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
}

void _handleProductClick(BuildContext context, Product product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => pdScreen(product: product),
    ),
  );
}
