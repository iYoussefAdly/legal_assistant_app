import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

class ChatBubbleAi extends StatelessWidget {
  final String message;
  final Image avatarImage;

  const ChatBubbleAi({
    super.key,
    required this.message,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: media.width * .12,
              height: media.width * .12,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(218, 168, 255, .4),
                    Color.fromRGBO(237, 228, 247, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: avatarImage.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: media.height * .015),

            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [Color.fromRGBO(218, 168, 255, .4),
            Color.fromRGBO(237, 228, 247, 1),],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(message, style: AppStyles.styleMedium14),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: media.width * .12,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffDAB5FF), Color(0xffE8C9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
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
