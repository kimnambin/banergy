import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/search.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mainDB.dart';
//import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const MaterialApp(
      home: pdScreen(
        product: null,
      ),
    ),
  );
}

//pd -> 프로덕트 디테일 줄임말
// ignore: camel_case_types
class pdScreen extends StatefulWidget {
  final Product? product;

  const pdScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _pdScreenState createState() => _pdScreenState();
}

// ignore: camel_case_types
class _pdScreenState extends State<pdScreen> {
  late List<Product> products = [];
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  bool isFavorite = false; // 하트 상태 변수

  @override
  void initState() {
    super.initState();
    fetchData(); // 데이터 가져오기
  }

  // 상품 데이터를 가져오는 비동기 함수
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('$baseUrl:8000/'),
    );
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> productList = json.decode(response.body);
        products = productList.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // 하트 아이콘 상태를 토글하는 함수
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFF1F2F7),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainpageApp()),
              );
            },
          ),
        ),
        //오류 시
        body: const Center(
          child: Text('정보를 불러올 수 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF1F2F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SearchScreen(
                        searchText: '',
                      )),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: _buildImage(context, widget.product!.frontproduct),
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFDDD7D7),
              thickness: 1.0,
              height: 5.0,
            ),
            const SizedBox(height: 16),
            _NOText({
              widget.product!.kategorie,
              widget.product!.name,
            }),
            //_buildText('이름:', widget.product!.name),
            const SizedBox(height: 30),
            //_buildImage(context, widget.product!.backproduct),
            _buildText({
              '알레르기 식품:': widget.product!.allergens,
            }),
          ],
        ),
      ),
    );
  }
}

Widget _buildText(Map<String, String> textMap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textMap.entries.map((entry) {
        return Text(
          '${entry.key} ${entry.value}',
          style: const TextStyle(fontSize: 14),
        );
      }).toList(),
    ),
  );
}

//앞에 텍스트 없이 내용만 가져오는 부분
// ignore: non_constant_identifier_names
Widget _NOText(Set<String> texts) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: texts.map((text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }).toList(),
  );
}

Widget _buildImage(BuildContext context, String imageUrl) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Center(
      child: Image.network(imageUrl, fit: BoxFit.cover),
    ),
  );
}
