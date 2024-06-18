import 'package:flutter/material.dart';
import 'package:kickexchange/core/preferences/colors.dart';

class Textformfields extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final Color borderColor;
  final dynamic Function(dynamic value)? validator;
  final TextInputType? textInputType;

  const Textformfields({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.onSuffixIconPressed,
    required this.borderColor,
    this.textInputType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.only(left: 24, top: 16, bottom: 16),
 suffixIcon: onSuffixIconPressed != null
            ? IconButton(
                onPressed: onSuffixIconPressed,
                icon:
                    Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              )
            : null,       
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
