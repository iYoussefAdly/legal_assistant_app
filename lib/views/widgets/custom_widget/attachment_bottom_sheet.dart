import 'package:flutter/material.dart';

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final popupColor = const Color.fromRGBO(231, 214, 248, 1);
    const contentColor = Color(0xff4A4A4A);

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
            _buildAttachmentOption(
              context: context,
              icon: Icons.image_outlined,  
              text: "Upload Image",
              onTap: () {
                print("Upload Image Clicked");
                Navigator.pop(context); 
              },
              color: contentColor,
            ),
            const SizedBox(height: 16), 

            _buildAttachmentOption(
              context: context,
              icon: Icons.description_outlined, 
              text: "Upload Document",
              onTap: () {
                print("Upload Document Clicked");
                Navigator.pop(context); 
              },
              color: contentColor,
            ),
             SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16), 
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}