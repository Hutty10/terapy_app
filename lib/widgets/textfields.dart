import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.onTapOutside,
    this.keyboardType,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
