import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
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
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        errorBorder: buildErrorBorder(),
        focusedErrorBorder: buildErrorBorder(),

        hintText: "Select your gender",
        hintStyle: AppStyles.styleRegular16,
      ),

      iconEnabledColor: Colors.white.withOpacity(0.85),
      iconDisabledColor: Colors.white.withOpacity(0.5),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
      items: const [
        DropdownMenuItem(value: "Male", child: Text("Male")),
        DropdownMenuItem(value: "Female", child: Text("Female")),
      ],
      onChanged: onChanged,
    );
  }
}
