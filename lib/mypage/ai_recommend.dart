// AI 추천(레시피 추천 / 위치 기반 추천) 화면입니다.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/auth_service.dart';
import 'package:flutter_banergy/common/ocr_service.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/main_filtering_allergies.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/product/like_product.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  await dotenv.load();
  runApp(const AiRecommend());
}

class AiRecommend extends StatefulWidget {
  const AiRecommend({super.key});

  @override
  State<AiRecommend> createState() => _AiRecommendState();
}

class _AiRecommendState extends State<AiRecommend> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  late final AuthService _authService = AuthService(baseUrl: _baseUrl);
  late final OcrService _ocrService = OcrService(baseUrl: _baseUrl);

  String? _authToken;
  final ImagePicker _imagePicker = ImagePicker();
  String _ocrResult = '';
  late final PageController _pageController;

  int _bottomNavIndex = 1;
  int _aiRecommendationIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final String? token = await _authService.loadValidAuthToken();
    if (!mounted) return;
    setState(() => _authToken = token);
  }

  Future<void> _uploadImage(File imageFile) async {
    final String result = await _ocrService.recognizeText(
      imageFile: imageFile,
      authToken: _authToken ?? '',
    );
    if (!mounted) return;
    setState(() => _ocrResult = result);
  }

  void _onAIRecommendationTapped(int index) {
    setState(() => _aiRecommendationIndex = index);
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
        title: const Text('AI 추천', textAlign: TextAlign.center),
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
              height: MediaQuery.of(context).size.height,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() => _aiRecommendationIndex = index);
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
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
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
      onTap: (int index) => _handleBottomNavigationTap(context, index),
    );
  }

  void _handleBottomNavigationTap(BuildContext context, int index) {
    setState(() => _bottomNavIndex = index);

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
        _showLensOptionsSheet(context);
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LPscreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MypageApp()),
        );
        break;
    }
  }

  void _showLensOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _pickAndScanImage(
                    context,
                    source: ImageSource.camera,
                  ),
                  child: const Text(
                    '카메라',
                    style: TextStyle(fontFamily: 'PretendardMedium'),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _pickAndScanImage(
                    context,
                    source: ImageSource.gallery,
                  ),
                  child: const Text(
                    '갤러리',
                    style: TextStyle(fontFamily: 'PretendardMedium'),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'QR/바코드',
                    style: TextStyle(fontFamily: 'PretendardMedium'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndScanImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    if (source == ImageSource.camera) {
      final PermissionStatus cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }
    }

    final XFile? pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile == null) return;

    try {
      await _uploadImage(File(pickedFile.path));
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Ocrresult(
            imagePath: pickedFile.path,
            ocrResult: _ocrResult,
          ),
        ),
      );
    } catch (error) {
      debugPrint('OCR failed: $error');
    }
  }
}

/// 레시피 추천 탭. 사진을 올리면 AI가 상품/레시피를 추천해 준다.
class ProductRecommendationPage extends StatefulWidget {
  const ProductRecommendationPage({
    super.key,
    required this.onButtonTapped,
    required this.selectedIndex,
  });

  final ValueChanged<int> onButtonTapped;
  final int selectedIndex;

  @override
  State<ProductRecommendationPage> createState() =>
      _ProductRecommendationPageState();
}

class _ProductRecommendationPageState
    extends State<ProductRecommendationPage> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String _aiResult = '';
  bool _isPhotoSelected = false; // 갤러리 버튼 클릭 여부

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _isPhotoSelected = true;
    });
  }

  Future<void> _addProduct(BuildContext context) async {
    try {
      final http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl:8000/AI/img'),
      );

      if (_image != null) {
        final http.ByteStream imageStream = http.ByteStream(_image!.openRead());
        final int length = await _image!.length();
        final http.MultipartFile multipartFile = http.MultipartFile(
          'image',
          imageStream,
          length,
          filename: _image!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final http.Response responseData =
            await http.Response.fromStream(response);
        final Map<String, dynamic> jsonData =
            json.decode(responseData.body) as Map<String, dynamic>;
        setState(() => _aiResult = jsonData['AI 분석결과'] as String);
      } else {
        debugPrint('Failed to get product recommendation: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('서버에서 오류가 발생했음: $error');
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
                  onPressed: () => _getImage(ImageSource.gallery),
                  icon: const Icon(
                    Icons.perm_media,
                    color: Color(0xFFA7A6A6),
                  ),
                  label: const Text(
                    '갤러리',
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
            if (_isPhotoSelected) _buildPhotoArea(),
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
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  _aiResult.isNotEmpty ? _aiResult : '상품 추천 내용이 여기에 표시됩니다.',
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
    if (_image == null) {
      return const Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: ColoredBox(color: Colors.white),
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Image.file(_image!),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _addProduct(context),
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text('검색', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(double.infinity, 45),
              backgroundColor: const Color.fromARGB(255, 29, 171, 102),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFFEBEBEB)),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 위치 기반 추천 탭. 현재 위치를 바탕으로 주변 식당/상품을 추천해 준다.
class RecipeRecommendationPage extends StatefulWidget {
  const RecipeRecommendationPage({
    super.key,
    required this.onButtonTapped,
    required this.selectedIndex,
  });

  final ValueChanged<int> onButtonTapped;
  final int selectedIndex;

  @override
  State<RecipeRecommendationPage> createState() =>
      _RecipeRecommendationPageState();
}

class _RecipeRecommendationPageState extends State<RecipeRecommendationPage> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  double? _longitude;
  double? _latitude;
  String _locationStatus = '위치 정보를 가져오는 중...';
  String _aiResult = '';
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      try {
        final Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _longitude = position.longitude;
          _latitude = position.latitude;
          _locationStatus =
              '현재 위치: (${_longitude!.toStringAsFixed(2)}, ${_latitude!.toStringAsFixed(2)})';
        });
      } catch (error) {
        setState(() => _locationStatus = '위치 정보를 가져오는데 실패했습니다.');
        debugPrint('Error getting location: $error');
      }
    } else if (status.isDenied) {
      setState(() => _locationStatus = '위치 권한이 거부되었습니다.');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _sendLocation(BuildContext context) async {
    final double? longitude = _longitude;
    final double? latitude = _latitude;
    if (longitude == null || latitude == null) {
      debugPrint('위치 정보가 설정되지 않았습니다.');
      return;
    }

    final Map<String, dynamic> locationData = {
      'longitude': double.parse(longitude.toStringAsFixed(3)),
      'latitude': double.parse(latitude.toStringAsFixed(3)),
      'inputText': _textController.text,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl:8000/AI/map'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(locationData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            json.decode(response.body) as Map<String, dynamic>;
        setState(() => _aiResult = jsonData['AI 분석결과'] as String);
      } else {
        debugPrint(
            'Failed to get product recommendation: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error during request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildToggleButtons(),
          const SizedBox(height: 20),
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
          Text(_locationStatus),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _sendLocation(context),
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        '검색',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  _aiResult.isNotEmpty ? _aiResult : '여기에 주변 식당 정보가 표시됩니다. ',
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
