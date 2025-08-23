import 'package:flutter/material.dart';

import 'package:rebot_flutter_app/utils/app_utils.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const LoginButton({super.key, required this.onPressed,  required this.text});

  final double fontSize = 18;
  final double letterSpacing = 1.2;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: AppUtils.hexToColor('#7BC9EC'),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 6),
                blurRadius: 8,
              ),
            ],
          ),
          child:  Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: letterSpacing,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
