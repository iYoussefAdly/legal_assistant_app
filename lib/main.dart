import 'package:flutter/material.dart';
import 'package:legal_assistant_app/views/chat_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ChatView());
  }
}