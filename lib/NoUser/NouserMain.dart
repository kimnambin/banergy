// 비회원(로그인하지 않은 사용자)이 보는 홈 화면입니다.
// OCR 업로드 같은 통신 로직은 lib/common/의 서비스 파일에 맡기고,
// 이 파일은 화면(UI)을 그리는 역할만 합니다.

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/NoUser/NouserOCRresult.dart';
import 'package:flutter_banergy/NoUser/Nouserfiltering.dart';
import 'package:flutter_banergy/appbar/home_search_widget.dart';
import 'package:flutter_banergy/common/ocr_service.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/main_category/category_header.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/product_detail.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const MaterialApp(
      home: NoUserMainpageApp(),
    ),
  );
}

class NoUserMainpageApp extends StatefulWidget {
  const NoUserMainpageApp({super.key});

  @override
  State<NoUserMainpageApp> createState() => _NoUserMainpageAppState();
}

class _NoUserMainpageAppState extends State<NoUserMainpageApp> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  late final OcrService _ocrService = OcrService(baseUrl: _baseUrl);

  final ImagePicker _imagePicker = ImagePicker();
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String _ocrResult = '';
  bool _isOcrInProgress = false;

  int _selectedIndex = 0;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<String> _imageList = ['assets/images/ad.png'];

  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isOcrInProgress = true);

    final String result =
        await _ocrService.recognizeTextAsGuest(imageFile: imageFile);

    if (!mounted) return;
    setState(() => _ocrResult = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Home_SearchWidget(), // 검색 위젯
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
                builder: (context) => const Nouserfiltering(),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    _buildImageSlider(),
                    _buildSliderIndicator(),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: HomeCategoryStrip()),
            const ProductGrid(), // 상품 그리드
            if (_isOcrInProgress) _buildOcrProgressOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildOcrProgressOverlay() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.5),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(
              '서버에 이미지 업로드 중... \n 최대 2~3분이 소요됩니다',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
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
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NoUserMainpageApp()),
        );
        break;
      case 1:
      case 3:
      case 4:
        showGuestOnlyDialog(context);
        break;
      case 2:
        _showLensOptionsSheet(context);
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
                  child: const Text('카메라'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _pickAndScanImage(
                    context,
                    source: ImageSource.gallery,
                  ),
                  child: const Text('갤러리'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _scanBarcode(context),
                  child: const Text('QR/바코드'),
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

    setState(() => _isOcrInProgress = true);

    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: const [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
      );
      if (croppedFile == null) return;

      final File croppedImageFile = File(croppedFile.path);
      await _uploadImage(croppedImageFile);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Ocrresult2(
            imagePath: croppedImageFile.path,
            ocrResult: _ocrResult,
          ),
        ),
      );
    } catch (error) {
      debugPrint('OCR failed: $error');
    } finally {
      if (mounted) setState(() => _isOcrInProgress = false);
    }
  }

  void _scanBarcode(BuildContext context) {
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

  Widget _buildImageSlider() {
    return CarouselSlider(
      carouselController: _controller,
      items: _imageList.map((String imageAsset) {
        return Builder(
          builder: (context) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(imageAsset, fit: BoxFit.fill),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 220,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          setState(() => _current = index);
        },
      ),
    );
  }

  Widget _buildSliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _imageList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12,
              height: 12,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withOpacity(_current == entry.key ? 0.9 : 0.4),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 비회원은 이용할 수 없는 기능을 눌렀을 때 보여주는 안내 다이얼로그.
void showGuestOnlyDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('비회원 이용불가'),
        content: const Text('비회원은 이용하실 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 29, 171, 102),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}

/// 비회원 홈 화면의 상품 그리드를 표시하는 위젯입니다.
class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  List<Product> _products = <Product>[];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl:8000/'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    final List<dynamic> rawProducts =
        json.decode(response.body) as List<dynamic>;
    if (!mounted) return;
    setState(() {
      _products = rawProducts
          .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    });
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
          return _GuestProductCard(
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

class _GuestProductCard extends StatelessWidget {
  const _GuestProductCard({required this.product, required this.onTap});

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
        child: Stack(
          children: [
            InkWell(
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
                  const SizedBox(height: 12.0),
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
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () => showGuestOnlyDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
