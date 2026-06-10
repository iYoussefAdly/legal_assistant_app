import 'package:flutter/material.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/attachment_option_tile.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff7A3E9F).withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
