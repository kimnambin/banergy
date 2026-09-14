// 인트로(온보딩) 페이지 3개가 함께 쓰는 레이아웃입니다.
// 위쪽 설명 문구 + 가운데 그림 + 아래쪽 초록색 "다음" 버튼으로 구성되며,
// 문구/그림/다음 버튼 동작만 각 페이지에서 채워 넣습니다.

import 'package:flutter/material.dart';

class IntroPageScaffold extends StatelessWidget {
  const IntroPageScaffold({
    super.key,
    required this.description,
    required this.illustrationAsset,
    required this.onNext,
  });

  /// 페이지 상단에 보여줄 설명 문구 위젯 (보통 RichText).
  final Widget description;

  /// 가운데에 보여줄 페이지 대표 그림.
  final String illustrationAsset;

  /// "다음" 버튼을 눌렀을 때 실행할 동작.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              description,
              const Spacer(flex: 10),
              Image.asset(illustrationAsset, width: 150, height: 100),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF03C95B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: onNext,
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PretendardSemiBold',
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
