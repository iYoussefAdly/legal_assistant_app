import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainerChat extends StatelessWidget {
  final IconData icon;
  const ContainerChat({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(231, 214, 248, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(icon, color: Colors.black, size: 25),
      ),
    );
  }
}
