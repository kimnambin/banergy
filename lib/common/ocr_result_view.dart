// OCR 결과 화면(회원용/비회원용)이 함께 쓰는 화면(UI)입니다.
// 데이터를 어떻게 가져올지는 각 화면이 맡고, 여기서는 결과를 보여주기만 합니다.

import 'dart:io';

import 'package:flutter/material.dart';

class OcrResultView extends StatelessWidget {
  const OcrResultView({
    super.key,
    required this.imagePath,
    required this.isLoading,
    required this.plainText,
    required this.highlightedTerms,
    required this.onBack,
    required this.onClose,
    this.showHeading = false,
  });

  /// 사용자가 촬영/선택한 이미지 경로.
  final String imagePath;

  /// OCR 결과를 아직 가져오는 중인지 여부.
  final bool isLoading;

  /// OCR로 읽은 전체 텍스트.
  final String plainText;

  /// 『...』로 감싸인 강조 표시 텍스트. 비어있지 않으면 경고 배너를 보여준다.
  final String highlightedTerms;

  /// 앱바 뒤로가기 버튼을 눌렀을 때 실행할 동작.
  final VoidCallback onBack;

  /// "닫기" 버튼을 눌렀을 때 실행할 동작.
  final VoidCallback onClose;

  /// 본문 상단에 "OCR 결과" 제목을 한 번 더 보여줄지 여부.
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR 결과', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: onBack,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.file(File(imagePath)),
                ),
              ),
              const Divider(
                color: Color(0xFFDDD7D7),
                thickness: 1.0,
                height: 5.0,
              ),
              if (showHeading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'OCR 결과',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 16),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('OCR 결과를 가져오는 중...', textAlign: TextAlign.center),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (highlightedTerms.isNotEmpty)
                        Container(
                          decoration: const BoxDecoration(color: Colors.yellow),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '사용자와 맞지 않은 상품입니다.',
                              style: TextStyle(fontSize: 20.0, color: Colors.black),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (plainText.isNotEmpty) Text(plainText),
                      if (highlightedTerms.isEmpty && plainText.isEmpty)
                        const Text('No text detected'),
                    ],
                  ),
                ),
              ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF03C95B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const SizedBox(
                  width: 50,
                  height: 30,
                  child: Center(
                    child: Text(
                      '닫기',
                      style:
                          TextStyle(fontFamily: 'PretendardSemiBold', fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
