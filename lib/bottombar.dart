// 상품 관련 화면들(바코드 스캔 결과, 상품 목록 등)에서 쓰는 공용 하단 탭바입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final ImagePicker _imagePicker = ImagePicker();
  final QrBarCodeScannerDialog _qrBarCodeScannerDialogPlugin =
      QrBarCodeScannerDialog();
  String _ocrResult = '';
  int _selectedIndex = 0;

  Future<void> _uploadImage(XFile pickedFile) async {
    final Uri url = Uri.parse('$_baseUrl:7000/ocr');
    final http.MultipartRequest request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', pickedFile.path));
    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final String responseData = await response.stream.bytesToString();
      final Map<String, dynamic> decodedData =
          jsonDecode(responseData) as Map<String, dynamic>;
      setState(() => _ocrResult = (decodedData['text'] as List).join('\n'));
    } else {
      setState(() => _ocrResult = 'Failed to perform OCR: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      onTap: (int index) => _handleTap(context, index),
    );
  }

  void _handleTap(BuildContext context, int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainpageApp()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Freeboard()),
        );
        break;
      case 2:
        _showLensOptionsSheet(context);
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
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
                  onPressed: () => _scanBarcode(context),
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
      await _uploadImage(pickedFile);
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
}
