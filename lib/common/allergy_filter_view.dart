// 알레르기 체크리스트 화면(검색창 + 체크박스 목록 + 기타 입력 + 적용 버튼)을 그려주는 공용 위젯입니다.
// 서버에 어떻게 저장할지는 화면마다 달라서, 그 부분은 onSubmit 콜백으로 각 화면에서 넘겨받습니다.

import 'package:flutter/material.dart';

import 'allergy_options.dart';
import 'allergy_selection.dart';

class AllergyFilterView extends StatefulWidget {
  const AllergyFilterView({
    super.key,
    required this.subtitle,
    required this.onBack,
    required this.onSubmit,
    required this.onSubmitted,
  });

  /// 체크박스 목록 위에 보여줄 안내 문구 (예: 기본 안내 문구, 또는 이미 저장된 알레르기 목록).
  final String subtitle;

  /// 뒤로가기 버튼을 눌렀을 때 실행할 동작.
  final VoidCallback onBack;

  /// 적용 버튼을 눌렀을 때, 최종 알레르기 목록을 서버로 보내는 동작. 성공 여부를 돌려줘야 합니다.
  final Future<bool> Function(List<String> allergies) onSubmit;

  /// 저장에 성공한 뒤 확인 버튼을 눌렀을 때 실행할 동작(다음 화면 이동 등).
  final VoidCallback onSubmitted;

  @override
  State<AllergyFilterView> createState() => _AllergyFilterViewState();
}

class _AllergyFilterViewState extends State<AllergyFilterView> {
  final AllergySelection _selection = AllergySelection();

  Future<void> _handleSubmitPressed() async {
    final List<String> allergies = _selection.buildSubmission();
    final bool success = await widget.onSubmit(allergies);

    if (!mounted) return;

    if (success) {
      _showResultDialog(message: '적용완료!!', onConfirm: widget.onSubmitted);
    } else {
      _showResultDialog(
        message: '다시 확인해주세요.',
        onConfirm: () => Navigator.of(context).pop(),
      );
    }
  }

  void _showResultDialog({
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알러지 필터링', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: widget.onBack,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Image.asset('images/000.jpeg', width: 80, height: 80),
            ),
            const SizedBox(height: 10),
            Text(
              widget.subtitle,
              style: const TextStyle(fontFamily: 'PretendardSemiBold'),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                style: const TextStyle(fontFamily: 'PretendardBold'),
                decoration: const InputDecoration(
                  hintText: '알레르기를 검색해보세요!!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  contentPadding: EdgeInsets.only(left: 30, bottom: 13),
                ),
                onChanged: (String value) {
                  setState(() => _selection.searchText = value);
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.white,
                child: _buildFilterGrid(),
              ),
            ),
            if (_selection.isOtherSelected) _buildOtherInput(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterGrid() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: (kAllergyOptions.length + 1) ~/ 2,
      itemBuilder: (BuildContext context, int rowIndex) {
        final int start = rowIndex * 2;
        final int end = (start + 2) < kAllergyOptions.length
            ? start + 2
            : kAllergyOptions.length;
        final List<String> rowOptions = kAllergyOptions.sublist(start, end);

        return Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              for (final String option in rowOptions)
                if (_selection.matchesSearch(option))
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: CheckboxListTile(
                        title: Text(option),
                        value: _selection.selected.contains(option),
                        onChanged: (bool? isChecked) {
                          setState(() {
                            _selection.toggle(option, isChecked ?? false);
                          });
                        },
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtherInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        onChanged: (String value) => _selection.otherText = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.green),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: '기타 알레르기를 입력해주세요.',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF03C95B),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: _handleSubmitPressed,
        child: const Text(
          '적용',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
