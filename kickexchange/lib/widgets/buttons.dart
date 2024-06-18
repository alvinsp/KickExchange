import 'package:flutter/material.dart';
import 'package:kickexchange/core/preferences/colors.dart';

class Buttons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Buttons({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16),
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.orange),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
    );
  }
}
