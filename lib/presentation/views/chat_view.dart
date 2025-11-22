import 'package:flutter/material.dart';
import 'package:legal_assistant_app/presentation/widgets/chat_widget/chat_view_body.dart';
class ChatView extends StatelessWidget {
  const ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffD1A2F5), Color(0xffE6DDF0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ChatViewBody(),
      ),
    );
  }
}
