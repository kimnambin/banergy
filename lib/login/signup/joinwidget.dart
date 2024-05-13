//회원가입 페이지에 달력과 성별 부분

import 'package:flutter/material.dart';

// 달력 위젯 http://rwdb.kr/datepicker/
class DatePickerButton extends StatefulWidget {
  const DatePickerButton({
    super.key,
    this.label = '',
    this.hintText = '',
    this.icon,
    this.iconColor = Colors.grey,
    this.hintTextColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.buttonWidth = double.infinity,
    this.buttonHeight = 60.0,
    this.iconSize = 24.0,
    this.hintTextSize = 16.0,
    this.backgroundColor = Colors.white,
    required this.controller,
    required this.onChanged,
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
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
          side: const BorderSide(
            color: Colors.grey,
          ),
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
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
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
    Key? key,
    this.label = '',
    this.hintText = '',
    this.icon,
    this.iconColor = Colors.grey,
    this.hintTextColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.buttonWidth = double.infinity,
    this.buttonHeight = 60.0,
    this.iconSize = 24.0,
    this.hintTextSize = 16.0,
    this.backgroundColor = Colors.white,
    required this.selectedGender,
    required this.onChanged,
  }) : super(key: key);

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
        ElevatedButton(
          onPressed: () => _selectGender(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius,
              side: const BorderSide(
                color: Colors.grey,
              ),
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

class InputField2 extends StatelessWidget {
  final bool isTextArea;
  final String hintText;
  final TextEditingController controller;

  const InputField2({
    this.isTextArea = false,
    this.hintText = "",
    required this.controller,
    super.key,
    required String? Function(dynamic value) validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTextArea)
          TextFormField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            controller: controller,
          )
        else
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
              ),
            ),
            controller: controller,
          ),
      ],
    );
  }
}
