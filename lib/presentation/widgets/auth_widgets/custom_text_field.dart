import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/core/utils/helpers/build_border.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.isItPassword,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
  });
  final String hintText;
  final bool isItPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isItPassword ? obscureText : false,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        errorBorder: buildErrorBorder(),
        focusedErrorBorder: buildErrorBorder(),
        hintText: widget.hintText,
        hintStyle: AppStyles.styleRegular16,
        suffixIcon: widget.isItPassword
            ? IconButton(
                onPressed: () {
                  obscureText = !obscureText;
                  setState(() {});
                },
                icon: obscureText
                    ? const Icon(Icons.visibility_off, color: Color(0xFFF6D3D3))
                    : const Icon(Icons.visibility, color: Color(0xFFF6D3D3)),
              )
            : null,
      ),
    );
  }
}
