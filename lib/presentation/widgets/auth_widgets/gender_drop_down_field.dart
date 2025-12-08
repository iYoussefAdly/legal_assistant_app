import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/helpers/build_border.dart';

class GenderDropdownField extends StatelessWidget {
  const GenderDropdownField({
    super.key,
    required this.onChanged,
    required this.selectedGender,
  });
  final void Function(String?) onChanged;
  final String? selectedGender;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      style: const TextStyle(color: Colors.white),
      dropdownColor: const Color(0xFF1E1E1E),
      hint: const Text(
        "Select your gender",
        style: TextStyle(color: Colors.white),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        errorBorder: buildErrorBorder(),
        focusedErrorBorder: buildErrorBorder(),
        errorStyle: const TextStyle(color: Color(0xffB0251E)),
      ),
      iconEnabledColor: Colors.white.withOpacity(0.85),
      iconDisabledColor: Colors.white.withOpacity(0.5),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
      items: [
        DropdownMenuItem(value: "Male", child: Text("Male", style: TextStyle(color: Colors.white))),
        DropdownMenuItem(value: "Female", child: Text("Female", style: TextStyle(color: Colors.white))),
      ],
      onChanged: onChanged,
    );
  }
}
