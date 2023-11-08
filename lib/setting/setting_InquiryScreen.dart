import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: InquiryScreen(),
  ));
}

//글로벌 키 생성 (폼 전송을 위한 것)
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//화면 이동
class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

// 폼 데이터를 저장
//타이틀 -> 제목 / 콘텐츠 -> 내용
class _InquiryScreenState extends State<InquiryScreen> {
  String? title = '';
  String? content = '';

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      label: '제목 *',
                      // 제목 부분 null 체크 후 할당
                      onSaved: (value) {
                        if (value != null) {
                          title = value;
                        }
                      },
                    ),
                    SizedBox(height: 20), //간격 벌리기용
                    InputField(
                      label: '내용 *',
                      isTextArea: true,
                      hintText: "수정 요청, 유의 사항 등등 문의",
                      //내용 부분 null 체크 후 할당
                      onSaved: (value) {
                        // null 체크 후 할당
                        if (value != null) {
                          content = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), //간격 벌리기 용
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    if (title != null && content != null) {
                      // InquiryDetailScreen으로 정보 전달
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InquiryDetailScreen(
                            //22
                            title: title,
                            content: content,
                          ),
                        ),
                      );
                    }
                  }
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
  final void Function(String?)? onSaved; //onsaved도 함수 표시

  InputField({
    required this.label,
    this.isTextArea = false,
    this.hintText = "",
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (isTextArea)
          TextFormField(
            maxLines: 10,
            onSaved: onSaved, //데이터 저장시 사용
            validator: (value) {
              if (value == null || value.isEmpty) {
                // null 및 빈 문자열 체크 -> 빈칸일 때 확인용ㄹ
                return '필수 입력 항목입니다.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
          )
        else
          TextFormField(
            onSaved: onSaved,
            validator: (value) {
              if (value == null || value.isEmpty)
              //빈칸 체크
              {
                return '필수 입력 항목입니다.';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
      ],
    );
  }
}

class InquiryDetailScreen extends StatelessWidget {
  final String? title; //제목 정의
  final String? content; //내용 정의

  InquiryDetailScreen({this.title, this.content});
  //제목과 내용 가져오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문의 화면'),
      ),
      body: Center(
        child: Column(
          //지금은 사용자에게도 보이지만 나중에는 우리만 보이도록 구현해도 좋을 듯
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('문의 화면 내용'),
            Text('제목: ${title ?? "N/A"}'), //가져온 제목 /"N/A"이건 눌 체크용
            Text('내용: ${content ?? "N/A"}'), //가져온 내용 /"N/A" null 첵
          ],
        ),
      ),
    );
  }
}

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
