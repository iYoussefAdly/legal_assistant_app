import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/features/chat/presentation/widgets/container_chat.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.onLogout,
    required this.onNewChat,
    required this.onMenu,
  });

  final VoidCallback onLogout;
  final VoidCallback onNewChat;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ContainerChat(
          height: 40,
          width: 40,
          borderRadius: 20,
          backgroundColor: Colors.grey[900],
          borderColor: Colors.grey[700],
          child: IconButton(
            icon: const Icon(CupertinoIcons.back,
                color: Colors.white, size: 20),
            onPressed: onLogout,
          ),
        ),
        ContainerChat(
          width: width * .3,
          height: height * .05,
          borderRadius: 30,
          backgroundColor: Colors.grey[900],
          borderColor: Colors.grey[700],
          child: GestureDetector(
            onTap: onNewChat,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New Chat',
                    style: AppStyles.styleSemitBold14
                        .copyWith(color: Colors.white)),
                SizedBox(width: width * .02),
                const Icon(Icons.restart_alt,
                    size: 20, color: Colors.white),
              ],
            ),
          ),
        ),
        ContainerChat(
          height: 40,
          width: 40,
          borderRadius: 20,
          backgroundColor: Colors.grey[900],
          borderColor: Colors.grey[700],
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 20),
            onPressed: onMenu,
          ),
        ),
      ],
    );
  }
}
