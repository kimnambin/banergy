// 카테고리 화면에서 상품을 2줄 그리드로 보여주는 공용 위젯입니다.
// 어떤 카테고리의 상품을 보여줄지는 categoryQuery로 전달받습니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/product/product_detail.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'product_query_service.dart';

class ProductGridSliver extends StatefulWidget {
  const ProductGridSliver({super.key, required this.categoryQuery});

  /// 상품을 조회할 때 사용할 카테고리 검색어 (예: '라면', '음료').
  final String categoryQuery;

  @override
  State<ProductGridSliver> createState() => _ProductGridSliverState();
}

class _ProductGridSliverState extends State<ProductGridSliver> {
  final ProductQueryService _service = ProductQueryService(
    baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost',
  );

  List<Product> _products = <Product>[];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final List<Product> products =
          await _service.fetchProducts(widget.categoryQuery);
      if (!mounted) return;
      setState(() => _products = products);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 목록을 불러오지 못했습니다: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final Product product = _products[index];
          return _ProductCard(
            product: product,
            onTap: () => _openProductDetail(context, product),
          );
        },
        childCount: _products.length,
      ),
    );
  }

  void _openProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pdScreen(product: product)),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
          onTap: onTap,
          child: Column(
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
        ),
      ),
    );
  }
}
