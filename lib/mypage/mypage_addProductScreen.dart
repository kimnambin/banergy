import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../mypage/mypage.dart';

void main() {
  runApp(const MaterialApp(
    home: AddProductScreen(),
  ));
}

class AddProductScreen extends StatefulWidget {
  final File? image;

  const AddProductScreen({Key? key, this.image}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _MyAppState();
}

class _MyAppState extends State<AddProductScreen> {
  late File? _image;
  final ImagePicker picker = ImagePicker();
  String parsedText = ''; // 추가: 이미지에서 추출된 텍스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  // getImage 함수 안에서 사용될 변수들을 함수 밖으로 이동
  late XFile? pickedFile;
  late String img64;

  // 이미지 가져오는 부분 수정

  Future getImage(ImageSource imageSource) async {
    pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      // 이미지를 base64로 변환
      var bytes = File(pickedFile!.path).readAsBytesSync();
      img64 = base64Encode(bytes);

      // OCR API 호출
      await _performOCR();

      setState(() {
        _image = File(pickedFile!.path);
      });
    }
  }

  // OCR을 수행
  Future<void> _performOCR() async {
    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64Image": "data:image/jpg;base64,$img64",
      "language": "kor"
    };
    var header = {"apikey": "K86733705788957"};

    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);

    setState(() {
      parsedText = result['ParsedResults'][0]['ParsedText'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("상품 추가")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  '상품추가',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                InputField(label: '제목', hintText: '제목을 입력하세요'),
                SizedBox(height: 20),
                InputField(
                  label: '상품 내용',
                  hintText: '간단한 상품 내용을 적어주세요.',
                ),
                SizedBox(height: 20),
                Text(
                  '최대한 공백이 없어야 인식이 잘됩니다.',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildPhotoArea(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    _buildElevatedButton("카메라", ImageSource.camera),
                    const SizedBox(width: 30),
                    _buildElevatedButton("갤러리", ImageSource.gallery),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'My',
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Column(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Image.file(_image!),
              ),
              const SizedBox(height: 20),
              Text(
                '식품 성분',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(parsedText), // 이미지에서 추출된 텍스트 표시
              ElevatedButton(
                onPressed: () {
                  _showDialog(parsedText);
                },
                child: Text('Show Dialog'),
              ),
            ],
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
          );
  }

  void _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('상품 정보'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  ElevatedButton _buildElevatedButton(String label, ImageSource imageSource) {
    return ElevatedButton(
      onPressed: () {
        getImage(imageSource);
      },
      child: Text(label),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;

  InputField({required this.label, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
