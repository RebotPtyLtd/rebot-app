import 'package:flutter/material.dart';
import 'package:rebot_flutter_app/utils/app_utils.dart';

class SimpleTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final String label;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final TextEditingController? controller;

  const SimpleTextField({
    super.key,
    this.keyboardType = TextInputType.text,
    required this.label,

    this.onChanged,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 3.0,
                color: AppUtils.hexToColor('#E9E9E9'),
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            obscureText: obscureText!,
            style: TextStyle(fontSize: 17.0, decoration: TextDecoration.none),
            decoration: InputDecoration.collapsed(
              hintText: label,
              hintStyle: TextStyle(fontSize: 17.0),
            ),
          ),
        ),
      ],
    );
  }
}
