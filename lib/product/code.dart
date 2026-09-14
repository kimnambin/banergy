// 바코드를 스캔한 뒤 결과를 보여주는 화면입니다.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/product_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:flutter_banergy/main.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key, required this.resultCode});

  final String resultCode;

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  List<Product> _products = <Product>[];
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl:8000/scan?barcode=${widget.resultCode}'),
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
          // pop으로 하면 오류가 떠서 홈스크린으로 대체
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainpageApp()),
          ),
        ),
      ),
      body: ScanResultGrid(products: _products),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class ScanResultGrid extends StatelessWidget {
  ScanResultGrid({super.key, required this.products});

  final List<Product> products;
  final QrBarCodeScannerDialog _qrBarCodeScannerDialogPlugin =
      QrBarCodeScannerDialog();

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '데이터베이스에 저장된 내용이 없습니다 ㅜ.ㅜ',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _rescan(context),
                child: const Text('다시찍기'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final Product product = products[index];
          return Card(
            child: InkWell(
              onTap: () => _openProductDetail(context, product),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      product.frontproduct,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(product.allergens),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _rescan(BuildContext context) {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: context,
      onCode: (String? code) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CodeScreen(resultCode: code ?? '스캔된 정보 없음'),
          ),
        );
      },
    );
  }

  void _openProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
    );
  }
}
