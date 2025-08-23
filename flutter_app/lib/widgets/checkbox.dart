import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final void Function(bool)? callback;
  final String label;
  final bool isChecked;

  const CustomCheckbox({
    super.key,
    required this.callback,
    required this.label,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (callback != null) callback!(!isChecked);
      },
      child: Row(
        children: <Widget>[
          Container(
            height: 20.0,
            width: 20.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black54),
            ),
            child: isChecked
                ? const Icon(Icons.check, size: 16)
                : const SizedBox(),
          ),
          const SizedBox(width: 10.0),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
