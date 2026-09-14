// 찜(좋아요)한 상품 목록에서 들어가는 상품 상세 화면입니다.
// (여기서 하트를 누르면 "좋아요 목록에서 빼기"만 할 수 있습니다.)

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/allergy_service.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/product/like_product.dart';
import 'package:flutter_banergy/product/product_detail_view.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const MaterialApp(
      home: LikedProductDetailScreen(product: null),
    ),
  );
}

class LikedProductDetailScreen extends StatefulWidget {
  const LikedProductDetailScreen({super.key, required this.product});

  final Product? product;

  @override
  State<LikedProductDetailScreen> createState() =>
      _LikedProductDetailScreenState();
}

class _LikedProductDetailScreenState extends State<LikedProductDetailScreen> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  late final AllergyService _allergyService =
      AllergyService(baseUrl: _baseUrl);

  String? _authToken;
  bool _hasMatchingAllergy = false;
  double _textScaleFactor = 1.0;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkAllergyMatch();
  }

  Future<void> _checkAllergyMatch() async {
    final LoggedInUserAllergyInfo? info =
        await _allergyService.loadLoggedInUserAllergies();
    if (!mounted || info == null) return;

    setState(() {
      _authToken = info.authToken;
      _hasMatchingAllergy = productMatchesAnyAllergy(
        widget.product!.allergens,
        info.savedAllergies,
      );
    });
  }

  // 좋아요 목록에서 삭제
  Future<void> _deleteProduct(Product product) async {
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl:8000/logindb/deletelike'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
      body: json.encode({'product_id': product.id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlike product');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product!;
    return ProductDetailView(
      product: product,
      onBack: () {
        // 새로고침을 위함
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LPscreen()),
        );
      },
      hasMatchingAllergy: _hasMatchingAllergy,
      textScaleFactor: _textScaleFactor,
      onZoomIn: () {
        setState(() {
          _textScaleFactor = (_textScaleFactor + 0.5)
              .clamp(ProductDetailView.minTextScaleFactor,
                  ProductDetailView.maxTextScaleFactor);
        });
      },
      onZoomOut: () {
        setState(() {
          _textScaleFactor = (_textScaleFactor - 0.5)
              .clamp(ProductDetailView.minTextScaleFactor,
                  ProductDetailView.maxTextScaleFactor);
        });
      },
      likeButton: IconButton(
        icon: Icon(
          _isLiked ? Icons.favorite_border : Icons.favorite,
          color: _isLiked ? Colors.grey : Colors.red,
        ),
        iconSize: 28,
        onPressed: () {
          setState(() => _isLiked = !_isLiked);
          _deleteProduct(product);
        },
      ),
    );
  }
}
