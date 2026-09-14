// 자유게시판(커뮤니티) 목록 화면입니다.

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/auth_service.dart';
import 'package:flutter_banergy/common/ocr_service.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard_write_screen.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../product/like_product.dart';

void main() async {
  await dotenv.load();
  runApp(const Freeboard());
}

class Freeboard extends StatefulWidget {
  const Freeboard({super.key});

  @override
  State<Freeboard> createState() => _FreeboardState();
}

class _FreeboardState extends State<Freeboard> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  late final AuthService _authService = AuthService(baseUrl: _baseUrl);
  late final OcrService _ocrService = OcrService(baseUrl: _baseUrl);

  String? _authToken;
  final ImagePicker _imagePicker = ImagePicker();
  String _ocrResult = '';
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.white,
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
      body: const FreeboardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FreeboardWriteScreen()),
          );
        },
        backgroundColor: const Color(0xFF03C95B),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 48),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
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
          icon: ImageIcon(AssetImage('assets/images/bubble-chat.png')),
          label: '커뮤니티',
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
          MaterialPageRoute(builder: (context) => const MainpageApp()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Freeboard()),
        );
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

class FreeboardList extends StatefulWidget {
  const FreeboardList({super.key});

  @override
  State<FreeboardList> createState() => _FreeboardListState();
}

class _FreeboardListState extends State<FreeboardList> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<freeDB>>(
        future: _fetchFreeboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final List<freeDB> posts = snapshot.data ?? const <freeDB>[];
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final freeDB post = posts[index];
              if (post.freetitle == null || post.freecontent == null) {
                return const SizedBox();
              }
              return _FreeboardPostTile(post: post);
            },
          );
        },
      ),
    );
  }

  Future<List<freeDB>> _fetchFreeboardData() async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$_baseUrl:8000/mypage/free'),
      );
      if (response.statusCode != 200) {
        throw Exception('데이터 가져오기 실패: ${response.statusCode}');
      }

      final List<dynamic> rawPosts = json.decode(response.body) as List<dynamic>;
      return rawPosts
          .map((dynamic item) => freeDB.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('데이터 가져오기 실패: $error');
    }
  }
}

class _FreeboardPostTile extends StatelessWidget {
  const _FreeboardPostTile({required this.post});

  final freeDB post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showPostDialog(context),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.freetitle}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('${post.freecontent}', textAlign: TextAlign.left),
                    const SizedBox(height: 8),
                    Text(
                      '댓글  ${_timeAgo(post.timestamp)}',
                      style: const TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(color: Colors.grey, thickness: 0.5, height: 0),
      ],
    );
  }

  void _showPostDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF1F2F7),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${post.freetitle}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text('${post.freecontent}', textAlign: TextAlign.left),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  String _timeAgo(String? timestamp) {
    if (timestamp == null) return '';

    final DateTime? parsedTime = DateTime.tryParse(timestamp);
    if (parsedTime == null) return '';

    final Duration difference = DateTime.now().difference(parsedTime);
    if (difference.inDays > 0) return '${difference.inDays}일 전';
    if (difference.inHours > 0) return '${difference.inHours}시간 전';
    if (difference.inMinutes > 0) return '${difference.inMinutes}분 전';
    return '방금 전';
  }
}
