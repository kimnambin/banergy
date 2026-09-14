// 카테고리 화면과 검색 화면이 함께 쓰는, "검색어로 상품 목록을 가져오는" 서버 통신 로직입니다.

import 'dart:convert';

import 'package:flutter_banergy/mainDB.dart';
import 'package:http/http.dart' as http;

/// 검색어(카테고리 이름 또는 사용자가 입력한 검색어)로 상품 목록을 조회하는 서비스.
class ProductQueryService {
  ProductQueryService({required this.baseUrl});

  final String baseUrl;

  /// [query] 키워드로 상품 목록을 서버에서 가져옵니다.
  /// 카테고리 화면의 "카테고리별 상품 목록"과 검색 화면의 "검색 결과"가 모두 이 방식으로 조회됩니다.
  Future<List<Product>> fetchProducts(String query) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl:8000/?query=$query'),
    );

    if (response.statusCode != 200) {
      throw Exception('상품 목록을 불러오지 못했습니다. (query: $query)');
    }

    final List<dynamic> rawProducts =
        json.decode(response.body) as List<dynamic>;
    return rawProducts
        .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
