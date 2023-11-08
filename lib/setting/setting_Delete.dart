import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Delete(),
  ));
}

class Delete extends StatelessWidget {
  const Delete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("회원 탈퇴하기"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '탈퇴하기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InputField(label: '계정 비밀번호', hintText: '계정 비밀번호를 입력하세요'),
              SizedBox(height: 20), //간격 벌리기 용
              InputField(label: '탈퇴 사유', hintText: '간단한 탈퇴 사유를 적어주세요.'),
              SizedBox(height: 20), //간격 벌리기 용
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteDetailScreen(),
                    ),
                  );
                },
                child: Text('회원탈퇴'),
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

// 탈퇴하게 되면 앱 나가지도록 구현하기!!
class DeleteDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
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
