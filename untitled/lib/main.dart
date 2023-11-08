import 'package:flutter/material.dart';
import 'InquiryScreen.dart'; //화면 변경을 위해 필수
import 'ChangeNick.dart';
import 'Changeidpw.dart';
import 'Delete.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('설정화면 만들기'),
          ),
          body: CustomerServiceHome(),
          bottomNavigationBar: BottomBar(), //이걸 사용해야 바텀 바 사용 가능!!
        ),
      ),
    );
  }
}

class CustomerServiceHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text(
                      '설정',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.menu), //햄버거 바 구현
                // 나중에 클릭하면 리스트가 뜨도록 구현해야 할 듯
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색',
                icon: Icon(Icons.search),
              ),
            ),
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 1,
            childAspectRatio: 8.0,
            children: <Widget>[
              buildGridItem(context, '닉네임 변경', ChangeNick()),
              buildGridItem(context, '비밀번호/아이디 변경', Changeidpw()),
              buildGridItem(context, '회원탈퇴', Delete()),
              buildGridItem(
                context,
                '문의하기',
                InquiryScreen(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 60,
            ),
          ],
        ),
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
