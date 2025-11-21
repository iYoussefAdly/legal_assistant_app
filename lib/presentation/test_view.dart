import 'package:flutter/material.dart';
import 'package:legal_assistant_app/presentation/views/sign_in_view.dart';
class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInView()),
          );
        },
        child: Text('click me :D', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}