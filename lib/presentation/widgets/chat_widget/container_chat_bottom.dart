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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xCC770000), // أحمر شفاف في الأعلى (خفّفته)
            Color(0x88AA3333), // درجة أفتح بشفافية
            Color(0x33FBECEC), // فاتح جدًا شبه أبيض مع لمعة
          ],
          stops: [0.0, 0.45, 1.0],
        ),

        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
