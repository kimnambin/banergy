import 'dart:convert';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mypage/mypage_Freeboard_WriteScreen.dart.dart';

void main() {
  runApp(const Freeboard());
}

class Freeboard extends StatelessWidget {
  const Freeboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("자유게시판 목록"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
      ),
      body: const FreeboardList(),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Freeboard_WriteScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FreeboardList extends StatelessWidget {
  const FreeboardList({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFreeboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<freeDB>? dataList = snapshot.data;
          return ListView.builder(
            itemCount: dataList?.length,
            itemBuilder: (context, index) {
              final freeDB item = dataList![index];
              if (item.freetitle != null && item.freecontent != null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '제목: ${item.freetitle}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('내용: ${item.freecontent}'),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        }
      },
    );
  }

  // 데이터 가져오기
  Future<List<freeDB>> fetchFreeboardData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.174:6000/free'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => freeDB.fromJson(item)).toList();
    } else {
      // 데이터 가져오기 실패 시 빈 목록 반환
      throw Exception('데이터 가져오기 실패 ㅠㅠ');
    }
  }
}
