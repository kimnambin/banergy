import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

void main() {
  runApp(const MaterialApp(
    home: AddProductScreen(),
  ));
}

class AddProductScreen extends StatefulWidget {
  final File? image;

  const AddProductScreen({super.key, this.image});

  @override
  State<AddProductScreen> createState() => _MyAppState();
}

class _MyAppState extends State<AddProductScreen> {
  late File? _image;
  final ImagePicker picker = ImagePicker();
  String parsedText = '';

  get langs => null; // 추가: 이미지에서 추출된 텍스트를 저장할 변수

  // 이미지 가져오기
  /*Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);


    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // 선택된 이미지로 OCR 수행
      _ocr(_image!.path);
    }
  }*/
  Future _getImageAndPerformOCR(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // 선택된 이미지로 OCR 수행
      _ocr(_image!.path);
    }
  }

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  // getImage 함수 안에서 사용될 변수들을 함수 밖으로 이동
  late XFile? pickedFile;
  late String img64;

  // 새로 해보는 이미지 가져오기
  void runFilePicker(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      _ocr(pickedFile.path);
    }
  }

  // OCR 수행
  void _ocr(String imagePath) async {
    try {
      // If the imagePath is a remote image, download it and save locally
      if (!kIsWeb &&
          (imagePath.startsWith("http://") ||
              imagePath.startsWith("https://"))) {
        // You can add code here to download the image if needed

        // For example, you can use the http package to download the image
        // http.Response response = await http.get(Uri.parse(imagePath));
        // File file = File('local_path_to_save_image.jpg');
        // await file.writeAsBytes(response.bodyBytes);

        // Set the local path of the downloaded image
        // imagePath = file.path;
      }

      // Set the loading state to true
      setState(() {});

      // Perform OCR using flutter_tesseract_ocr
      var ocrText =
          await FlutterTesseractOcr.extractText(imagePath, language: 'kor');

      // Set the loading state to false
      setState(() {
        parsedText = ocrText;
      });
    } catch (e) {
      print('OCR failed: $e');
      // Handle the OCR failure, show a message, or take appropriate action
    }
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
              /* 이미지에서 추출된 텍스트 표시
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300, // 원하는 최대 너비 설정
                ),
                child: Text(
                  parsedText,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  
                ),
              ),*/
              ElevatedButton(
                onPressed: () {
                  _showDialog(parsedText);
                },
                child: Text('자세히 보기'),
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
          content: SingleChildScrollView(
            child: Text(text),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('상품 추가하기'),
            ),
          ],
        );
      },
    );
  }

/*
  ElevatedButton _buildElevatedButton(String label, ImageSource imageSource) {
    return ElevatedButton(
      onPressed: () {
        getImage(imageSource);
      },
      child: Text(label),
    );
  }*/
  ElevatedButton _buildElevatedButton(String label, ImageSource imageSource) {
    return ElevatedButton(
      onPressed: () {
        _getImageAndPerformOCR(imageSource);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
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
                    _buildElevatedButton(
                      "카메라",
                      ImageSource.camera,
                    ),
                    const SizedBox(width: 30),
                    _buildElevatedButton("갤러리", ImageSource.gallery),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
