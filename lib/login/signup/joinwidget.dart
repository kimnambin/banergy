//회원가입 페이지에 달력과 성별 부분

import 'package:flutter/material.dart';

// 달력 위젯 http://rwdb.kr/datepicker/
class DatePickerButton extends StatefulWidget {
  const DatePickerButton({
    super.key,
    this.label = '',
    this.hintText = '',
    this.icon,
    this.iconColor = const Color(0xFF666666),
    this.hintTextColor = Colors.grey,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 60.0,
    this.iconSize = 24.0,
    this.hintTextSize = 16.0,
    this.backgroundColor = Colors.white,
    required this.controller,
    required this.onChanged,
    required TextStyle hintStyle,
    required Border border,
  });

  final String label;
  final String hintText;
  final IconData? icon;
  final Color iconColor;
  final Color hintTextColor;
  final double buttonWidth;
  final double buttonHeight;
  final double iconSize;
  final double hintTextSize;
  final Color backgroundColor;
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF7A7A7A),
            width: 1.0,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () => _selectDate(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          elevation: 0,
          minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              widget.icon,
              color: widget.iconColor,
              size: widget.iconSize,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: widget.controller,
                enabled: false,
                style: TextStyle(
                  fontSize: widget.hintTextSize,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: widget.hintTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        widget.controller.text = pickedDate.toLocal().toString().split(' ')[0];
        widget.onChanged(widget.controller.text); // 변경된 날짜를 부모 위젯으로 전달
      });
    }
  }
}

// 성별 부분 해보기
// ignore: camel_case_types
class genderbox extends StatefulWidget {
  const genderbox({
    super.key,
    this.label = '',
    this.hintText = '',
    this.icon,
    this.iconColor = const Color(0xFF666666),
    this.hintTextColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.buttonWidth = double.infinity,
    this.buttonHeight = 60.0,
    this.iconSize = 24.0,
    this.hintTextSize = 16.0,
    this.backgroundColor = Colors.white,
    required this.selectedGender,
    required this.onChanged,
    required TextStyle hintStyle,
    required Border border,
  });

  final String label;
  final String hintText;
  final IconData? icon;
  final Color iconColor;
  final Color hintTextColor;
  final BorderRadius borderRadius;
  final double buttonWidth;
  final double buttonHeight;
  final double iconSize;
  final double hintTextSize;
  final Color backgroundColor;
  final String? selectedGender;
  final void Function(String?) onChanged;

  @override
  _genderboxState createState() => _genderboxState();
}

class _genderboxState extends State<genderbox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          child: ElevatedButton(
            onPressed: () => _selectGender(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor,
              elevation: 0,
              minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
              shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: widget.iconSize,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedGender ?? widget.hintText,
                        style: TextStyle(
                          color: widget.selectedGender != null
                              ? Colors.black
                              : widget.hintTextColor,
                          fontSize: widget.hintTextSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectGender(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('성별'),
              ListTile(
                title: const Text('남자'),
                leading: Radio(
                  value: '남자',
                  groupValue: widget.selectedGender,
                  onChanged: (String? value) {
                    widget.onChanged(value);
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ),
              ListTile(
                title: const Text('여자'),
                leading: Radio(
                  value: '여자',
                  groupValue: widget.selectedGender,
                  onChanged: (String? value) {
                    widget.onChanged(value);
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
