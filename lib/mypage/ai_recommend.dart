// ignore_for_file: library_private_types_in_public_api

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
import "package:geolocator/geolocator.dart";
import 'dart:io';

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
  String aiResult = ''; // 이미지 결과
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context)
                  .size
                  .height, // Ensure it takes the full height
              child: PageView(
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
            ),
          ],
        ),
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

// =======================레시피 추천==========================================================================
class ProductRecommendationPage extends StatefulWidget {
  final Function(int) onButtonTapped;
  final int selectedIndex;

  const ProductRecommendationPage({
    super.key,
    required this.onButtonTapped,
    required this.selectedIndex,
  });

  @override
  _ProductRecommendationPageState createState() =>
      _ProductRecommendationPageState();
}

class _ProductRecommendationPageState extends State<ProductRecommendationPage> {
  List<String> allergies = [];
  bool isLoading = true;
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String aiResult = '';
  bool _isPhotoSelected = false; //갤러리 버튼 클릭 여부
  // final TextEditingController _textController = TextEditingController(); //인풋 부분

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
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allergies = List<String>.from(data['allergies'] ?? []);
          isLoading = false;
        });
      } else {
        if (kDebugMode) {
          print('Failed to load allergies: ${response.statusCode}');
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching allergies: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isPhotoSelected = true; // 버튼 클릭 여부 트루로!!
      });
    }
  }

  Future<void> _addProduct(BuildContext context) async {
    // String inputText = _textController.text; //인풋내용

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl:8000/AI/img'),
      );

      // request.fields['inputText'] = inputText;

      if (_image != null) {
        var imageStream = http.ByteStream(_image!.openRead());
        var length = await _image!.length();
        var multipartFile = http.MultipartFile(
          'image',
          imageStream,
          length,
          filename: _image!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonData = json.decode(responseData.body); // JSON 파싱

        setState(() {
          aiResult = jsonData['AI 분석결과']; // AI 분석 결과 저장
          // aiResult = '임시 분석 결과입니다';
        });
      } else {
        if (kDebugMode) {
          print('Failed to get product recommendation: ${response.statusCode}');
        }
        // _showErrorDialog(context, '다시 한번 확인해주세요');
      }
    } catch (e) {
      if (kDebugMode) {
        print('서버에서 오류가 발생했음: $e');
      }
      // _showErrorDialog(context, '서버에서 오류가 발생했습니다.');
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
            onPressed: () {
              widget.onButtonTapped(0);
            },
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
            onPressed: () {
              widget.onButtonTapped(1);

              _addProduct(context);
            },
            child: Text(
              '위치기반 추천',
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            if (!_isPhotoSelected) ...[
              Text(
                '사진을 넣어 레시피를 추천 받아 보세요 ☺️☺️',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  icon: const Icon(
                    Icons.perm_media,
                    color: Color(0xFFA7A6A6),
                  ),
                  label: const Text(
                    "갤러리",
                    style: TextStyle(color: Color(0xFFA7A6A6)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromRGBO(227, 227, 227, 1.0)),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            if (_isPhotoSelected) ...[
              _buildPhotoArea(),
            ],
          ],
        ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // AI 분석 결과 표시
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  aiResult.isNotEmpty ? aiResult : '상품 추천 내용이 여기에 표시됩니다.',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return Center(
      child: Column(
        children: [
          if (_image != null) ...[
            SizedBox(
              width: 150,
              height: 150,
              child: Image.file(_image!),
            ),
            const SizedBox(height: 20),
            // TextField(
            //   controller: _textController,
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30.0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30.0),
            //       borderSide: BorderSide(color: Colors.grey[300]!),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30.0),
            //       borderSide: const BorderSide(color: Colors.green),
            //     ),
            //     contentPadding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //     hintText: '가장 심한 알레르기 하나를 입력해주세요.',
            //     hintStyle: TextStyle(fontSize: 13, color: Colors.grey[600]),
            //   ),
            // ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (_image != null) {
                  _addProduct(context);
                }
              },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text("검색", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, 45),
                backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xFFEBEBEB)),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ] else ...[
            Container(
              width: 250,
              height: 250,
              color: Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================식당 추천===============================================
class RecipeRecommendationPage extends StatefulWidget {
  final Function(int) onButtonTapped;
  final int selectedIndex;

  const RecipeRecommendationPage({
    super.key,
    required this.onButtonTapped,
    required this.selectedIndex,
  });

  @override
  _RecipeRecommendationPageState createState() =>
      _RecipeRecommendationPageState();
}

class _RecipeRecommendationPageState extends State<RecipeRecommendationPage> {
  List<String> allergies = [];
  bool isLoading = true;
  double? longitude;
  double? latitude;
  String locationStatus = '위치 정보를 가져오는 중...';
  String aiResult = ''; //ai 결과부분
  final TextEditingController _textController = TextEditingController(); //인풋 부분

  @override
  void initState() {
    super.initState();
    fetchAllergies();
    getLocation();
  }

  Future<List<String>> fetchAllergies() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    if (token == null) {
      return []; // 토큰이 없을 때 빈 리스트 반환
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['allergies'] ?? []);
      } else {
        debugPrint('Failed to load allergies: ${response.statusCode}');
        return []; // 알레르기 정보 로드 실패 시 빈 리스트 반환
      }
    } catch (e) {
      debugPrint('Error fetching allergies: $e');
      return []; // 오류 발생 시 빈 리스트 반환
    }
  }

  Future<void> getLocation() async {
    // 위치 권한을 확인하고 요청
    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            // ignore: deprecated_member_use
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          longitude = position.longitude;
          latitude = position.latitude;
          locationStatus =
              '현재 위치: (${longitude!.toStringAsFixed(2)}, ${latitude!.toStringAsFixed(2)})';
        });
      } catch (e) {
        setState(() {
          locationStatus = '위치 정보를 가져오는데 실패했습니다.';
        });
        debugPrint('Error getting location: $e');
      }
    } else if (status.isDenied) {
      setState(() {
        locationStatus = '위치 권한이 거부되었습니다.';
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> sendLocation(BuildContext context) async {
    if (longitude == null || latitude == null) {
      debugPrint('위치 정보가 설정되지 않았습니다.');
      return;
    }
    String inputText = _textController.text;

    debugPrint('Input Text: $inputText');

    // 소수점 3자리까지 포맷 후 double 타입으로 변환
    final double formattedLongitude =
        double.parse(longitude!.toStringAsFixed(3));
    final double formattedLatitude = double.parse(latitude!.toStringAsFixed(3));

    final Map<String, dynamic> locationData = {
      'longitude': formattedLongitude,
      'latitude': formattedLatitude,
      'inputText': inputText,
    };

    final String requestBody = jsonEncode(locationData);

    debugPrint('Sending location data: $requestBody'); // 보내는 데이터 출력

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}:8000/AI/map'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // 응답 데이터를 직접 파싱
        var jsonData = json.decode(response.body); // JSON 파싱

        setState(() {
          aiResult = jsonData['AI 분석결과']; // AI 분석 결과 저장
        });
        // 다이얼로그 호출을 버튼 클릭 시 조정
      } else {
        debugPrint(
            'Failed to get product recommendation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during request: $e');
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
          const SizedBox(height: 10),
          _buildLocationStatus(),
          const SizedBox(height: 20),
          _buildRecommendationContent('위치 기반'),
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
              '위치기반 추천',
              style: TextStyle(
                color: widget.selectedIndex == 1 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationStatus() {
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
            '현재 위치',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(locationStatus),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await sendLocation(context);
                      },
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        "검색",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 35),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFEBEBEB)),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // 검색 입력
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    hintText: '가장 심한 알레르기 하나를 입력해주세요.',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // AI 분석 결과 표시
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  aiResult.isNotEmpty ? aiResult : '여기에 주변 식당 정보가 표시됩니다. ',
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
