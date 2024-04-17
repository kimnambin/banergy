// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: AddProductScreen(),
  ));
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _addtitleController = TextEditingController();
  final TextEditingController _addcontentController = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _addProduct(BuildContext context) async {
    final String addtitle = _addtitleController.text;
    final String addcontent = _addcontentController.text;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.143.174:6000/add'),
      );

      // 이미지 파일 추가
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

      // 텍스트 데이터 추가
      request.fields['addtitle'] = addtitle;
      request.fields['addcontent'] = addcontent;

      var response = await request.send();

      if (response.statusCode == 200) {
        // 성공 시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('확인 후 업로드 될 예정입니다'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    //Navigator.push(
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MypageApp(),
                      ),
                    );
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        // 실패 시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('다시 한번 확인해주세요'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // 오류 발생 시
      print('서버에서 오류가 발생했음: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("상품 추가"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/000.jpeg',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  '상품추가',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                InputField(
                  label: '제목',
                  hintText: '제목을 입력하세요',
                  controller: _addtitleController,
                ),
                const SizedBox(height: 20),
                InputField(
                  label: '상품 내용',
                  hintText: '간단한 상품 내용을 적어주세요.',
                  controller: _addcontentController,
                ),
                const SizedBox(height: 20),
                _buildPhotoArea(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _getImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text("카메라",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 29, 171, 102),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFEBEBEB)),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15), // 간격 조절
                    ElevatedButton.icon(
                      onPressed: () {
                        _getImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.perm_media, color: Colors.white),
                      label: const Text("갤러리",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 29, 171, 102),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFEBEBEB)),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    if (_image != null) {
      return Column(
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: Image.file(_image!),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              if (_image != null) {
                _addProduct(context);
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("추가하기", style: TextStyle(color: Colors.white)),
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
      );
    } else {
      return Container(
        width: 300,
        height: 300,
        color: Colors.grey,
      );
    }
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;

  const InputField({
    super.key,
    required this.label,
    this.hintText = "",
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
