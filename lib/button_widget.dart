import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({required this.text, required this.onClicked, super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onClicked,
        child: Align(
          alignment: Alignment.center,
          child: Text(text,
              style: const TextStyle(
                  fontSize: 24, color: Color.fromRGBO(25, 140, 25, 100)),
              textAlign: TextAlign.center),
        ),
      );
}
