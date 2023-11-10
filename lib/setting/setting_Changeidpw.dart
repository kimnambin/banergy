import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Changeidpw(),
  ));
}

class Changeidpw extends StatelessWidget {
  const Changeidpw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("비번 변경하기"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0), //화면 간격부분
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '비밀번호 변경하기',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30), //간격 벌리기 용
                InputField(
                  //class InputField 적용해야 이렇게 사용 가능!!
                  title: '현재 비밀번호',
                  labels: ['', ''],
                  hintTexts: ['현재 비밀번호 입력', '현재 비밀번호 확인'],
                ),
                SizedBox(height: 20), //간격 벌리기 용
                InputField(
                  title: '새 비밀번호',
                  labels: ['', ''],
                  hintTexts: ['새로운 비밀번호 입력', '새로운 비밀번호 확인'],
                ),
                SizedBox(height: 20), //간격 벌리기 용
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeidpwDetailScreen(),
                        ),
                      );
                    },
                    child: Text('비밀번호 변경')),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String title;
  final List<String> labels; //라벨 2개를 사용하기 위함
  final List<String> hintTexts; // 힌트텍 2개를 사용하기 위함

//이것도 중요요소
  InputField(
      {required this.title, required this.labels, required this.hintTexts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        for (int i = 0; i < labels.length; i++) //반복문을 사용함으로써 2개 이상 사용가능
          Column(
            children: [
              Text(
                labels[i],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: hintTexts[i],
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// 변경 적용되게 구현하기
class ChangeidpwDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경하기'),
      ),
      body: Center(
        child: Text('변경 내용'), // 변경 적용되게 구현하기
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
