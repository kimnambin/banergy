import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main_category/IconSlider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_banergy/mainDB.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AinpageApp(),
    ),
  );
}

class AinpageApp extends StatelessWidget {
  final File? image;
  const AinpageApp({super.key, this.image});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식품 알레르기 관리 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 50, 160, 107),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final picker = ImagePicker();
  late String img64;
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String? authToken; // 사용자의 인증 토큰
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  // 사용자의 로그인 상태를 확인하고 인증 토큰을 가져옵니다.
  Future<void> _checkLoginStatus() async {
    final token = await _loginUser();
    if (token != null) {
      final isValid = await _validateToken(token);
      setState(() {
        authToken = isValid ? token : null;
      });
    }
  }

  // 사용자가 이미 로그인했는지 확인합니다.
  Future<String?> _loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // 토큰의 유효성을 확인합니다.
  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:3000/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error validating token: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Text('하트를 넣어보자'), // Flexible 추가
        ],
      ),
      body: const Stack(
        children: [
          Column(
            children: [
              IconSlider(),
              SizedBox(height: 16),
              Expanded(
                child: ProductGrid(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductGrid extends StatefulWidget {
  const ProductGrid({Key? key}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late List<Product> products = [];
  List<int> likedProducts = [];

  String? authToken;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://192.168.112.174:8000/'),
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

  // 좋아요를 추가하는 함수 수정
  void _updateLikeStatus(int index) async {
    const String apiUrl = 'http://192.168.112.174:3000/like';
    final Map<String, dynamic> body = {
      'product_id': products[index].id.toString(),
    };
    print('Request Body: $body');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // 사용자의 인증 토큰을 헤더에 포함
        },
      );

      if (response.statusCode == 201) {
        print('좋아요 추가 성공');
        // 좋아요를 추가한 경우, likedProducts 리스트에 해당 인덱스를 추가
        setState(() {
          likedProducts.add(index);
        });
      } else if (response.statusCode == 409) {
        print('이미 좋아요를 눌렀습니다.');
      } else {
        print('서버 오류: ${response.statusCode}');
        print('메시지: ${response.body}');
      }
    } catch (error) {
      print('네트워크 오류: $error');
    }
  }

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              _handleProductClick(context, products[index]);
            },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.network(
                          products[index].frontproduct,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index].name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          Text(products[index].allergens),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: likedProducts.contains(index)
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border),
                    onPressed: () {
                      _toggleLikedStatus(index);
                      _updateLikeStatus(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleLikedStatus(int index) {
    setState(() {
      if (likedProducts.contains(index)) {
        likedProducts.remove(index);
      } else {
        likedProducts.add(index);
      }
    });
  }

  void _handleProductClick(BuildContext context, Product product) {
    double textScaleFactor = 1.0;
    double maxTextScaleFactor = 2.0;
    double minTextScaleFactor = -2.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('상품 정보'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText('카테고리:' as Map<String, String>,
                        product.kategorie, textScaleFactor),
                    _buildText('이름:' as Map<String, String>, product.name,
                        textScaleFactor),
                    _buildImage(context, product.frontproduct),
                    _buildImage(context, product.backproduct),
                    _buildText('알레르기 식품:' as Map<String, String>,
                        product.allergens, textScaleFactor),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              textScaleFactor += 0.5;
                              if (textScaleFactor > maxTextScaleFactor) {
                                textScaleFactor = maxTextScaleFactor;
                              }
                            });
                          },
                          child: const Icon(Icons.zoom_in, color: Colors.black),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              textScaleFactor -= 0.5;
                              if (textScaleFactor < minTextScaleFactor) {
                                textScaleFactor = minTextScaleFactor;
                              }
                            });
                          },
                          child:
                              const Icon(Icons.zoom_out, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('닫기'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildText(
      Map<String, String> textMap, String kategorie, double textScaleFactor) {
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
}
