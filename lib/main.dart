import 'package:flutter/material.dart';
import 'package:legal_assistant_app/views/chat_view.dart';
import 'package:legal_assistant_app/views/test_view.dart';

void main() {
  runApp(const LegalAssistantApp());
}

class LegalAssistantApp extends StatelessWidget {
  const LegalAssistantApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ChatView(),
    );
  }
}
