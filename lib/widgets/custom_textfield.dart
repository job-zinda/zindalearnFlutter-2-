import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  final String hint;
  final int? maxLength;

  final bool isPassword;

  final bool isVisible;

  final bool showToggle;

  final VoidCallback? onToggle;

  final TextInputType keyboardType;

  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;

  final void Function(String)? onChanged;
    final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLength,
    this.isPassword = false,
    this.isVisible = false,
    this.showToggle = false,
    this.onToggle,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
     this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // final width = Responsive.width(context);

    return TextFormField(
      controller: controller,

      obscureText: isPassword && !isVisible,

      keyboardType: keyboardType,

      inputFormatters: inputFormatters,

      validator: validator,

      onChanged: onChanged,
      maxLength: maxLength,

      decoration: InputDecoration(
        hintText: hint,
        counterText: "",

       prefixIcon: Icon(
    prefixIcon ??
        (isPassword
            ? Icons.lock_outline
            : Icons.person_outline),
  ),

        suffixIcon: showToggle
            ? IconButton(
                onPressed: onToggle,
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              )
            : null,
      ),
    );
  }
}
