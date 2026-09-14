// 앱바에서 검색한 후 보여지는 검색 결과 화면입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/product_search_bar.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/main_category/category_header.dart';
import 'package:flutter_banergy/mypage/mypage_filtering_allergies.dart';
import 'package:flutter_banergy/product/like_product.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.searchText});

  final String searchText;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> _products = <Product>[];
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl:8000/?query=${widget.searchText}'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    final List<dynamic> rawProducts =
        json.decode(response.body) as List<dynamic>;
    setState(() {
      _products = rawProducts
          .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const ProductSearchBar(), // 검색 위젯
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/filter.png',
              width: 24.0,
              height: 24.0,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilteringPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LPscreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const HomeCategoryStrip(),
          Expanded(
            child: SearchResultGrid(products: _products),
          ),
        ],
      ),
    );
  }
}

class SearchResultGrid extends StatefulWidget {
  const SearchResultGrid({super.key, required this.products});

  final List<Product> products;

  @override
  State<SearchResultGrid> createState() => _SearchResultGridState();
}

class _SearchResultGridState extends State<SearchResultGrid> {
  final List<int> _likedIndexes = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final Product product = widget.products[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _openProductDetail(context, product),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 90,
                        child: Center(
                          child: Image.network(
                            product.frontproduct,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          product.allergens,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: _likedIndexes.contains(index)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onPressed: () => _toggleLiked(index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleLiked(int index) {
    setState(() {
      if (_likedIndexes.contains(index)) {
        _likedIndexes.remove(index);
      } else {
        _likedIndexes.add(index);
      }
    });
  }

  void _openProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}
