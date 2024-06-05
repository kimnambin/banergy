// appbar 검색하는 부분

import 'package:flutter/material.dart';
//import 'package:flutter_banergy/appbar/menu.dart';
import 'package:flutter_banergy/appbar/search.dart';
import 'package:flutter_banergy/mainDB.dart';
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
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * 1.0,
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

//여기가 검색 결과
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
