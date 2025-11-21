import 'package:flutter/material.dart';
import 'package:legal_assistant_app/presentation/test_view.dart';

void main() {
  runApp(const LegalAssistantApp());
}

class LegalAssistantApp extends StatelessWidget {
  const LegalAssistantApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestView(),
    );
  }
}
