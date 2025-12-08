import 'package:flutter/material.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/attachment_option_tile.dart';

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({
    super.key,
    required this.onImageSelected,
    required this.onDocumentSelected,
  });

  final VoidCallback onImageSelected;
  final VoidCallback onDocumentSelected;

  @override
  Widget build(BuildContext context) {
    
    // ✨ اللون الجديد: أبيض ناصع (لضمان أعلى تباين على الخلفية الحمراء الداكنة) ✨
    final Color popupColor = Colors.white; 
    
    // يمكنك استخدام هذا اللون كبديل إذا أردت لمسة أرجوانية خفيفة جداً:
    // final Color popupColor = const Color(0xffF0E6FF); // أرجواني فاتح جداً (تقريباً أبيض)

    return Container(
      decoration: BoxDecoration(
        color: popupColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        // إضافة ظل خفيف أو حدود بلون الهوية (الأرجواني الداكن) لجعله يبرز
        boxShadow: [
          BoxShadow(
            color: const Color(0xff7A3E9F).withOpacity(0.3), // لون الظل أرجواني داكن
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AttachmentOptionTile(
              // يفضل أن يكون لون الأيقونة بنفس لون الزر الرئيسي (الأرجواني الداكن)
              icon: Icons.image_outlined,
              title: 'Upload Image',
              onTap: () {
                Navigator.pop(context);
                onImageSelected();
              },
            ),
            const SizedBox(height: 16),
            AttachmentOptionTile(
              // يفضل أن يكون لون الأيقونة بنفس لون الزر الرئيسي (الأرجواني الداكن)
              icon: Icons.description_outlined,
              title: 'Upload Document',
              onTap: () {
                Navigator.pop(context);
                onDocumentSelected();
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}