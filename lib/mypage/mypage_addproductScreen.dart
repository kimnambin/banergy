// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MaterialApp(
    home: AddProductScreen(),
  ));
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _addtitleController = TextEditingController();
  final TextEditingController _addcontentController = TextEditingController();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

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
        Uri.parse('$baseUrl:8000/mypage/add'),
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
                        builder: (context) => const MyHomePage(),
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
        centerTitle: true,
        backgroundColor: const Color(0xFFF1F2F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
        ),
      ),
      //bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '상품추가',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                InputField(
                  hintText: '상품명',
                  controller: _addtitleController,
                  isTextArea: false,
                ),
                const SizedBox(height: 20),
                const InputField(
                  hintText: '추가할 내용을 적어주세요.',
                  isTextArea: true,
                ),
                _buildPhotoArea(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _getImage(ImageSource.camera);
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFFA7A6A6),
                      ),
                      label: const Text("카메라",
                          style: TextStyle(
                            color: Color(0xFFA7A6A6),
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFEBEBEB)),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30), // 간격 조절
                    ElevatedButton.icon(
                      onPressed: () {
                        _getImage(ImageSource.gallery);
                      },
                      icon: const Icon(
                        Icons.perm_media,
                        color: Color(0xFFA7A6A6),
                      ),
                      label: const Text(
                        "갤러리",
                        style: TextStyle(
                          color: Color(0xFFA7A6A6),
                        ),
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
            width: 250,
            height: 250,
            child: Image.file(_image!),
          ),
          const SizedBox(height: 10),
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
        width: 250,
        height: 250,
        color: Colors.white,
      );
    }
  }
}

class InputField extends StatelessWidget {
  final bool isTextArea;
  final String hintText;
  final TextEditingController? controller;

  const InputField({
    super.key,
    this.hintText = "",
    this.controller,
    this.isTextArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTextArea)
          TextFormField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            controller: controller,
          )
        else
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
              ),
            ),
            controller: controller,
          ),
      ],
    );
  }
}
