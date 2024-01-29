//코드가 너무 길어져 login 폴더 선언 분리

import 'package:flutter/material.dart';

// 인풋 필드 선언
class BanergyInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final IconData icon;
  final Color iconColor;
  final Color? hintTextColor;
  final BorderRadius borderRadius;

  const BanergyInputField({
    super.key,
    required this.label,
    this.hintText,
    required this.icon,
    required this.iconColor,
    this.hintTextColor,
    required this.borderRadius,
    required TextEditingController controller,
  });

//인풋 필드 내용
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 입력 항목입니다.';
              //여기에 회원가입 할 때 입력한 정보랑 동일 한지 확인
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
            ),
            prefixIcon: Icon(icon, color: iconColor),
          ),
        ),
      ],
    );
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
    this.iconColor = Colors.grey,
    this.hintTextColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.buttonWidth = double.infinity,
    this.buttonHeight = 60.0,
    this.iconSize = 24.0,
    this.hintTextSize = 16.0,
    this.backgroundColor = Colors.white,
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
  @override
  // ignore: library_private_types_in_public_api
  _genderboxState createState() => _genderboxState();
}

// ignore: camel_case_types
class _genderboxState extends State<genderbox> {
  String? _selectedGender;
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
                    if (_selectedGender == null)
                      Text(
                        widget.hintText,
                        style: TextStyle(
                          color: widget.hintTextColor,
                          fontSize: widget.hintTextSize,
                        ),
                      ),
                    if (_selectedGender != null)
                      Text(
                        _selectedGender!,
                        style: TextStyle(
                          color: Colors.black,
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
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ),
              ListTile(
                title: const Text('여자'),
                leading: Radio(
                  value: '여자',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
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

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

//달력 설정
class _DatePickerButtonState extends State<DatePickerButton> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        //shadowColor: Colors.transparent,
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
          Text(
            widget.hintText,
            style: TextStyle(
              color: widget.hintTextColor,
              fontSize: widget.hintTextSize,
            ),
          ),
        ],
      ),
    );
  }
}
