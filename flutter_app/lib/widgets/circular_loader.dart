import 'package:flutter/material.dart';
import 'package:rebot_flutter_app/utils/app_utils.dart';

class CircularLoader extends StatelessWidget {
  final Color? backgroundColor;
  const CircularLoader({super.key, this.backgroundColor});
  final double size = 50;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppUtils.hexToColor('#7BC9EC'),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: CircularProgressIndicator(backgroundColor: Colors.white),
    );
  }
}
