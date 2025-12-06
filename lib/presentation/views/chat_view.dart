import 'package:flutter/material.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/chat_view_body.dart';
import 'package:legal_assistant_app/presentation/widgets/splash_widgets/custom_background.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CustomBackground(child: ChatViewBody()));
  }
}
