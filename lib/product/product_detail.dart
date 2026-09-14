// 메인 화면 등에서 들어가는 상품 상세 화면입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/allergy_service.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/product/product_detail_view.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const MaterialApp(
      home: ProductDetailScreen(product: null),
    ),
  );
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product? product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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

  Future<void> _likeProduct(Product product) async {
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl:8000/logindb/like'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
      body: json.encode({'product_id': product.id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle like');
    }
    if (!mounted) return;
    setState(() => product.isHearted = !product.isHearted);
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product!;
    return ProductDetailView(
      product: product,
      onBack: () => Navigator.pop(context),
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
          _isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked ? Colors.red : Colors.grey,
        ),
        iconSize: 28,
        onPressed: () {
          setState(() => _isLiked = !_isLiked);
          _likeProduct(product);
        },
      ),
    );
  }
}
