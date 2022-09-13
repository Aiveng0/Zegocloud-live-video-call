import 'package:flutter/material.dart';

class TestTextField extends StatelessWidget {
  const TestTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.maxLength,
    this.maxLines = 1,
    this.style,
    this.contentPadding,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final int? maxLength;
  final int? maxLines;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF3c4043),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: contentPadding ?? const EdgeInsets.all(12),
        hintText: hintText,
        labelText: labelText,
      ),
      style: style,
      maxLines: maxLines,
      maxLength: maxLength,
    );
  }
}
