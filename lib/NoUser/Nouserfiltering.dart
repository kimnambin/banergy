// 비회원 사용자가 알레르기를 선택하는 화면입니다.
// 체크리스트 UI는 공용 위젯(AllergyFilterView)이 그려주고, 이 파일은 "비회원용 저장 방식"과
// "어디로 이동할지"만 결정합니다.

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/NoUser/NouserMain.dart';
import 'package:flutter_banergy/common/allergy_filter_view.dart';
import 'package:flutter_banergy/common/allergy_service.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const Nouserfiltering());
}

class Nouserfiltering extends StatelessWidget {
  const Nouserfiltering({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FilteringPage(),
    );
  }
}

/// 비회원 알레르기 필터링 화면. 로그인 없이 바로 사용할 수 있습니다.
class FilteringPage extends StatelessWidget {
  const FilteringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AllergyService service = AllergyService(
      baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost',
    );

    return AllergyFilterView(
      subtitle: '해당하는 알레르기를 체크해주세요',
      onSubmit: service.submitGuestAllergies,
      onBack: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstApp()),
        );
      },
      onSubmitted: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoUserMainpageApp()),
        );
      },
    );
  }
}
