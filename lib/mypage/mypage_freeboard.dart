import 'dart:convert';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage_Freeboard_WriteScreen.dart.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Freeboard extends StatelessWidget {
  const Freeboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "커뮤니티",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF1F2F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          },
        ),
      ),
      //backgroundColor: const Color(0xFFF1F2F7),
      body: FreeboardList(),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Freeboard_WriteScreen()),
          );
        },
        backgroundColor: const Color(0xFF03C95B),
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 48,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FreeboardList extends StatelessWidget {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  FreeboardList({super.key});

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
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // 클릭 시 AlertDialog 표시
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFFF1F2F7),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    //'${item.freetitle}',
                                    '사용자 이름 :',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${item.freetitle}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${item.freecontent}',
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.freetitle}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${item.freecontent}',
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '댓글  ${_getTimeDifference(item.timestamp)}',
                                  style: const TextStyle(
                                    color: Color(0xFF3C3C3C),
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 0,
                    ),
                  ],
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
    try {
      final response = await http.get(Uri.parse('$baseUrl:6000/free'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // 시간을 변환하여 데이터 생성
        return data.map((item) => freeDB.fromJson(item)).toList();
      } else {
        throw Exception('데이터 가져오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('데이터 가져오기 실패: $e');
    }
  }

  String _getTimeDifference(String? timestamp) {
    if (timestamp == null) {
      return '';
    }

    // Try to parse the timestamp
    final parsedTime = DateTime.tryParse(timestamp);
    if (parsedTime == null) {
      return '';
    }

    // Calculate the time difference
    final difference = DateTime.now().difference(parsedTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
