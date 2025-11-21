import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
   required this.isItPassword,
  });
  final String hintText;
  final bool isItPassword;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isItPassword? obscureText:false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        hintText: widget.hintText,
        hintStyle: AppStyles.styleRegular16,
        suffixIcon:widget.isItPassword? IconButton(
          onPressed: () {
            obscureText = !obscureText;
            setState(() {
              
            });
          },
          icon: obscureText
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ):null,
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xff75707A)),
    );
  }
}
