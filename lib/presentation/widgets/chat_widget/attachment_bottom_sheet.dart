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
    final popupColor = const Color.fromRGBO(231, 214, 248, 1);

    return Container(
      decoration: BoxDecoration(
        color: popupColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AttachmentOptionTile(
              icon: Icons.image_outlined,
              title: 'Upload Image',
              onTap: () {
                Navigator.pop(context);
                onImageSelected();
              },
            ),
            const SizedBox(height: 16),
            AttachmentOptionTile(
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