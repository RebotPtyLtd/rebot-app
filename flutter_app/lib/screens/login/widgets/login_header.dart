import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final Color Function(String) hexToColor;

  const LoginHeader({
    super.key,
    required this.hexToColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: hexToColor('#EB96B7'),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
        Column(
          children: [
            const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 3,
              width: 50,
              color: hexToColor('#D7D7D7'),
            ),
          ],
        ),
      ],
    );
  }
}
