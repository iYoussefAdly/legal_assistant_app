import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainerChatBottom extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final double borderRadius;
  const ContainerChatBottom({
    super.key,
    this.height,
    this.width,
    required this.child,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(218, 168, 255, .4),
            Color.fromRGBO(237, 228, 247, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
