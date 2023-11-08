import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: InquiryScreen(),
  ));
}

class InquiryScreen extends StatelessWidget {
  const InquiryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("문의하기"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '문의하기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InputField(label: '제목 *'),
              SizedBox(height: 20), // 간격 벌리기용
              InputField(label: '내용 *', isTextArea: true),
              SizedBox(height: 20), // 간격 벌리기용
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InquiryDetailScreen(),
                    ),
                  );
                },
                child: Text('문의하기'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final bool isTextArea;
  final String hintText;

  InputField(
      {required this.label, this.isTextArea = false, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        isTextArea
            ? TextField(
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "수정 요청 , 유의 사항 등등 문의",
            border: OutlineInputBorder(),
          ),
        )
            : TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

// 이 부분이 나중에 문의를 하면 문의가 업로드된 부분임
class InquiryDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문의 화면'),
      ),
      body: Center(
        child: Text('문의 화면 내용'),
      ),
    );
  }
}

//하단바
class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black38,
        labelStyle: TextStyle(
          fontSize: 17,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.home,
              size: 20,
            ),
            text: 'Home',
          ),
          Tab(
            //여긴 나중에 카메라 모양처럼 둥글게 구현하기
            icon: Icon(
              Icons.camera,
              size: 20,
            ),
            text: 'camera',
          ),
          Tab(
            icon: Icon(
              Icons.people,
              size: 20,
            ),
            text: 'My',
          ),
        ],
      ),
    );
  }
}