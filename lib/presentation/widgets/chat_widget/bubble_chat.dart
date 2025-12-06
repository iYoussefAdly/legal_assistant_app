import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  // final Image avatarImage;

  const ChatBubble({
    super.key,
    required this.message,
    // required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xCC770000), // أحمر شفاف في الأعلى (خفّفته)
                      Color(0x88AA3333), // درجة أفتح بشفافية
                      Color(0x33FBECEC), // فاتح جدًا شبه أبيض مع لمعة
                    ],
                    stops: [0.0, 0.45, 1.0],
                  ),

                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(message, style: AppStyles.styleMedium14),
              ),
            ),

            SizedBox(width: media.height * .015),
            Container(
              width: media.width * .12,
              height: media.width * .12,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xCC770000), // أحمر شفاف في الأعلى (خفّفته)
                    Color(0x88AA3333), // درجة أفتح بشفافية
                    Color(0x33FBECEC), // فاتح جدًا شبه أبيض مع لمعة
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),

                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
                // image: DecorationImage(image: avatarImage.image, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: media.width * .12,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC770000), // أحمر شفاف في الأعلى (خفّفته)
                  Color(0x88AA3333), // درجة أفتح بشفافية
                  Color(0x33FBECEC), // فاتح جدًا شبه أبيض مع لمعة
                ],
                stops: [0.0, 0.45, 1.0],
              ),

              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
