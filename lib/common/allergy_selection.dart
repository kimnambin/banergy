// 알레르기 체크박스의 선택 상태와 검색어 필터링을 다루는 파일입니다.
// 화면을 그리는 코드(위젯)와 분리해서, 여기서는 "무엇이 선택되었는지" 계산하는 로직만 담당합니다.

import 'allergy_options.dart';

/// 알레르기 체크박스들의 선택 상태와 검색어 필터링을 관리하는 클래스.
class AllergySelection {
  final List<String> selected = <String>[];
  String searchText = '';
  bool isOtherSelected = false;
  String? otherText;

  /// [option]이 현재 검색어에 걸리는지 확인합니다.
  bool matchesSearch(String option) {
    if (searchText.isEmpty) {
      return true;
    }
    return option.toLowerCase().contains(searchText.toLowerCase());
  }

  /// 체크박스를 눌렀을 때 선택 상태를 갱신합니다.
  void toggle(String option, bool isChecked) {
    if (option == kOtherAllergyOption) {
      isOtherSelected = isChecked;
    }

    if (selected.contains(option)) {
      selected.remove(option);
      return;
    }

    if (option != kOtherAllergyOption) {
      selected.add(option);
    }
  }

  /// 제출 직전에 "기타" 선택을 사용자가 입력한 텍스트로 바꿔서 최종 목록을 만듭니다.
  List<String> buildSubmission() {
    final List<String> submission = List<String>.from(selected);
    final String? otherTextValue = otherText;
    if (isOtherSelected && otherTextValue != null && otherTextValue.isNotEmpty) {
      submission.remove(kOtherAllergyOption);
      submission.add(otherTextValue);
    }
    return submission;
  }
}
