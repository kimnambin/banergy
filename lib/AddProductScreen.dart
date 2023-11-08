import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  File? _image; // 이미지 담을 변수
  final ImagePicker picker = ImagePicker();

//이미지 가져오기
  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("상품 추가")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30, width: double.infinity),
          _buildPhotoArea(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildElevatedButton("카메라", ImageSource.camera),
              const SizedBox(width: 30),
              _buildElevatedButton("갤러리", ImageSource.gallery),
            ],
          ),
        ],
      ),
      //bottomNavigationBar: BottomBar(),
      bottomNavigationBar: BottomNavigationBar(
        // 바텀바 추가
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
    return _image != null || widget.image != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: Image.file(_image ?? widget.image!),
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
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

/*class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black38,
        labelStyle: const TextStyle(
          fontSize: 17,
        ),
        tabs: [
          Tab(
            icon: const Icon(
              Icons.home,
              size: 20,
            ),
            text: 'Home',
          ),
          Tab(
            icon: const Icon(
              Icons.camera,
              size: 20,
            ),
            text: 'camera',
          ),
          Tab(
            icon: const Icon(
              Icons.people,
              size: 20,
            ),
            text: 'My',
          ),
        ],
      ),
    );
  }
}*/
