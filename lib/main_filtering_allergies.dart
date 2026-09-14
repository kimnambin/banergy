// 홈 화면에서 진입하는 "로그인 회원용" 알레르기 필터링 화면입니다.
// 체크리스트 UI는 공용 위젯(AllergyFilterView)이 그려주고, 이 파일은 로그인 상태 확인,
// 이미 저장된 알레르기 불러오기, "회원용 저장 방식"과 "어디로 이동할지"만 담당합니다.

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/common/allergy_filter_view.dart';
import 'package:flutter_banergy/common/allergy_service.dart';
import 'package:flutter_banergy/main.dart';

void main() {
  runApp(const FilteringAllergies());
}

class FilteringAllergies extends StatelessWidget {
  const FilteringAllergies({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainFilteringPage(),
    );
  }
}

/// 로그인한 회원이 홈 화면에서 진입하는 알레르기 필터링 화면.
class MainFilteringPage extends StatefulWidget {
  const MainFilteringPage({super.key});

  @override
  State<MainFilteringPage> createState() => _MainFilteringPageState();
}

class _MainFilteringPageState extends State<MainFilteringPage> {
  final AllergyService _service = AllergyService(
    baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost',
  );

  String? _authToken;
  List<String> _savedAllergies = <String>[];

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser();
  }

  Future<void> _loadLoggedInUser() async {
    final LoggedInUserAllergyInfo? info =
        await _service.loadLoggedInUserAllergies();
    if (!mounted) return;

    setState(() {
      _authToken = info?.authToken;
      _savedAllergies = info?.savedAllergies ?? <String>[];
    });
  }

  void _goToHomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String subtitle = _savedAllergies.isNotEmpty
        ? _savedAllergies.join(', ')
        : '해당하는 알레르기를 체크해주세요';

    return AllergyFilterView(
      subtitle: subtitle,
      onBack: _goToHomeScreen,
      onSubmit: (List<String> allergies) {
        return _service.submitMemberAllergies(
          authToken: _authToken,
          allergies: allergies,
        );
      },
      onSubmitted: _goToHomeScreen,
    );
  }
}
