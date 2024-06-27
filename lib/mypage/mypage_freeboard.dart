import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/mypage/mypage_Freeboard_WriteScreen.dart.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  _FreeboardState createState() => _FreeboardState();
}

class _FreeboardState extends State<Freeboard>
    with SingleTickerProviderStateMixin {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String? authToken; // 사용자의 인증 토큰
  final ImagePicker _imagePicker = ImagePicker(); // 이미지 피커 인스턴스
  //final _qrBarCodeScannerDialogPlugin =
  //    QrBarCodeScannerDialog(); // QR/바코드 스캐너 플러그인 인스턴스
  String? code; // 바코드
  String resultCode = ''; // 스캔된 바코드 결과
  String ocrResult = ''; // OCR 결과
  bool isOcrInProgress = false; // OCR 작업 진행 여부
  final picker = ImagePicker(); // 이미지 피커 인스턴스
  late String img64; // 이미지를 Base64로 인코딩한 결과

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  // 이미지 업로드 및 OCR 작업을 수행합니다.
  Future<void> _uploadImage(XFile pickedFile) async {
    setState(() {
      isOcrInProgress = true; // 이미지 업로드 시작
    });

    final url = Uri.parse('$baseUrl:8000/logindb/ocr');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $authToken';
    request.files
        .add(await http.MultipartFile.fromPath('image', pickedFile.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var decodedData = jsonDecode(responseData);
      setState(() {
        ocrResult = decodedData['text'].join('\n'); // OCR 결과 업데이트
      });
    } else {
      setState(() {
        ocrResult =
            'Failed to perform OCR: ${response.statusCode}'; // OCR 실패 메시지 업데이트
      });
    }
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
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error validating token: $e');
      return false;
    }
  }

  int _selectedIndex = 1; // 현재 선택된 바텀 네비게이션 바 아이템의 인덱스
  //int _current = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "커뮤니티",
          textAlign: TextAlign.center,
        ),
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
      body: const FreeboardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Freeboard_WriteScreen()),
          );
        },
        backgroundColor: const Color(0xFF03C95B),
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 48,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green, // 선택된 아이템의 색상
        unselectedItemColor: Colors.black, // 선택되지 않은 아이템의 색상
        selectedLabelStyle:
            const TextStyle(color: Colors.green), // 선택된 아이템의 라벨 색상
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/home.png'),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/bubble-chat.png'),
            ),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/lens.png'),
            ),
            label: '렌즈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/heart.png'),
            ),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/person.png'),
            ),
            label: '마이 페이지',
          ),
        ],
        onTap: (index) async {
          setState(() {
            _selectedIndex = index; // 선택된 인덱스 업데이트
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Freeboard()));
          } else if (index == 2) {
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
                            var cameraStatus = await Permission.camera.status;
                            if (!cameraStatus.isGranted) {
                              await Permission.camera.request();
                            }
                            final pickedFile = await _imagePicker.pickImage(
                              source: ImageSource.camera,
                            );

                            setState(() {
                              // 이미지 선택 후에 진행 바를 나타냅니다.
                              isOcrInProgress = true;
                            });

                            try {
                              await _uploadImage(pickedFile!);
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
                                // OCR 작업 완료 후에 진행 바를 숨깁니다.
                                isOcrInProgress = false;
                              });
                            }
                          },
                          child: const Text(
                            '카메라',
                            style: TextStyle(fontFamily: 'PretendardMedium'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await _imagePicker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              isOcrInProgress = true;
                            });
                            try {
                              // OCR 수행
                              await _uploadImage(pickedFile!);

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
                          },
                          child: const Text(
                            '갤러리',
                            style: TextStyle(fontFamily: 'PretendardMedium'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            //   context: context,
                            //   onCode: (code) {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => CodeScreen(
                            //           resultCode: code ?? "스캔된 정보 없음",
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // );
                          },
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
          } else if (index == 3) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LPscreen()));
          } else if (index == 4) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MypageApp()),
            );
          }
        },
      ),
    );
  }
}

class FreeboardList extends StatefulWidget {
  const FreeboardList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FreeboardListState createState() => _FreeboardListState();
}

class _FreeboardListState extends State<FreeboardList> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFreeboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<freeDB>? dataList = snapshot.data;
          return ListView.builder(
            itemCount: dataList?.length,
            itemBuilder: (context, index) {
              final freeDB item = dataList![index];
              if (item.freetitle != null && item.freecontent != null) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFFF1F2F7),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${item.freetitle}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${item.freecontent}',
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
                                  '${item.freetitle}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${item.freecontent}',
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '댓글  ${_getTimeDifference(item.timestamp)}',
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
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 0,
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          );
        }
      },
    );
  }

  Future<List<freeDB>> fetchFreeboardData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl:8000/mypage/free'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => freeDB.fromJson(item)).toList();
      } else {
        throw Exception('데이터 가져오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('데이터 가져오기 실패: $e');
    }
  }

  String _getTimeDifference(String? timestamp) {
    if (timestamp == null) {
      return '';
    }

    final parsedTime = DateTime.tryParse(timestamp);
    if (parsedTime == null) {
      return '';
    }

    final difference = DateTime.now().difference(parsedTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
