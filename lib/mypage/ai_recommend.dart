import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/main_filtering_allergies.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/product/like_product.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await dotenv.load();
  runApp(const AiRecommend());
}

class AiRecommend extends StatefulWidget {
  const AiRecommend({super.key});

  @override
  _AiRecommendState createState() => _AiRecommendState();
}

class _AiRecommendState extends State<AiRecommend>
    with SingleTickerProviderStateMixin {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String? authToken;
  final ImagePicker _imagePicker = ImagePicker();
  String resultCode = '';
  String ocrResult = '';
  bool isOcrInProgress = false;
  late String img64;
  List<String> userAllergies = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of _pageController
    super.dispose();
  }

  Future<void> _uploadImage(XFile pickedFile) async {
    setState(() {
      isOcrInProgress = true;
    });

    final url = Uri.parse('$baseUrl:8000/logindb/ocr');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $authToken'
      ..files.add(await http.MultipartFile.fromPath('image', pickedFile.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedData = jsonDecode(responseData);
        setState(() {
          ocrResult = decodedData['text'].join('\n');
        });
      } else {
        setState(() {
          ocrResult = 'Failed to perform OCR: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        ocrResult = 'OCR processing error: $e';
      });
    } finally {
      setState(() {
        isOcrInProgress = false;
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    final token = await _loginUser();
    if (token != null) {
      final isValid = await _validateToken(token);
      setState(() {
        authToken = isValid ? token : null;
      });
    }
  }

  Future<String?> _loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userAllergies = List<String>.from(data['allergies'] ?? []);
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error validating token: $e');
      }
      return false;
    }
  }

  int _bottomNavIndex = 1;
  int _aiRecommendationIndex = 0;
  // final PageController _pageController = PageController();

  void _onAIRecommendationTapped(int index) {
    setState(() {
      _aiRecommendationIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI 추천", textAlign: TextAlign.center),
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
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/filter.png',
              width: 24.0,
              height: 24.0,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FilteringAllergies()),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _aiRecommendationIndex = index;
          });
        },
        children: [
          ProductRecommendationPage(
            onButtonTapped: _onAIRecommendationTapped,
            selectedIndex: _aiRecommendationIndex,
          ),
          RecipeRecommendationPage(
            onButtonTapped: _onAIRecommendationTapped,
            selectedIndex: _aiRecommendationIndex,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(color: Colors.green),
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/ai.png')),
            label: 'AI 추천',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/lens.png')),
            label: '렌즈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/heart.png')),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/person.png')),
            label: '마이 페이지',
          ),
        ],
        onTap: (index) async {
          setState(() {
            _bottomNavIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainpageApp()),
              );
              break;
            case 1:
              // AI 추천 페이지는 현재 페이지이므로 아무 작업도 하지 않음
              break;
            case 2:
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _handleImagePick(ImageSource.camera);
                            },
                            child: const Text('카메라',
                                style:
                                    TextStyle(fontFamily: 'PretendardMedium')),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _handleImagePick(ImageSource.gallery);
                            },
                            child: const Text('갤러리',
                                style:
                                    TextStyle(fontFamily: 'PretendardMedium')),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {},
                            child: const Text('QR/바코드',
                                style:
                                    TextStyle(fontFamily: 'PretendardMedium')),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LPscreen()));
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MypageApp()),
              );
              break;
          }
        },
      ),
    );
  }

  Future<void> _handleImagePick(ImageSource source) async {
    var cameraStatus = await Permission.camera.status;
    if (source == ImageSource.camera && !cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      isOcrInProgress = true;
    });

    try {
      await _uploadImage(pickedFile);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Ocrresult(
            imagePath: pickedFile.path,
            ocrResult: ocrResult,
          ),
        ),
      );
    } catch (e) {
      debugPrint('OCR failed: $e');
    } finally {
      setState(() {
        isOcrInProgress = false;
      });
    }
  }
}

class ProductRecommendationPage extends StatefulWidget {
  final Function(int) onButtonTapped;
  final int selectedIndex;

  const ProductRecommendationPage({
    Key? key,
    required this.onButtonTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _ProductRecommendationPageState createState() =>
      _ProductRecommendationPageState();
}

class _ProductRecommendationPageState extends State<ProductRecommendationPage> {
  List<String> allergies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllergies();
  }

  Future<void> fetchAllergies() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allergies = List<String>.from(data['allergies'] ?? []);
          isLoading = false;
        });
      } else {
        print('Failed to load allergies: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching allergies: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildToggleButtons(),
          const SizedBox(height: 10),
          _buildAllergyFilterStatus(),
          const SizedBox(height: 10),
          _buildRecommendationContent('레시피 추천'),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.selectedIndex == 0 ? Colors.green : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => widget.onButtonTapped(0),
            child: Text(
              '레시피 추천',
              style: TextStyle(
                color: widget.selectedIndex == 0 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.selectedIndex == 1 ? Colors.green : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => widget.onButtonTapped(1),
            child: Text(
              '레시피 추천',
              style: TextStyle(
                color: widget.selectedIndex == 1 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllergyFilterStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '알레르기 필터링 현황',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          isLoading
              ? const CircularProgressIndicator()
              : Text('필터링된 알레르기: ${allergies.join(", ")}'),
        ],
      ),
    );
  }

  Widget _buildRecommendationContent(String title) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('상품 추천 내용이 여기에 표시됩니다.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeRecommendationPage extends StatelessWidget {
  final Function(int) onButtonTapped;
  final int selectedIndex;

  const RecipeRecommendationPage({
    Key? key,
    required this.onButtonTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToggleButtons(),
        //_buildAllergyFilterStatus(),
        //_buildRecommendationContent('레시피 추천'),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => onButtonTapped(0),
              child: const Text(
                '상품 추천',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => onButtonTapped(1),
              child: const Text(
                '레시피 추천',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
