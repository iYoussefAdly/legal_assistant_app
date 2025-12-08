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
        color: const Color(0xCCFFFFFF), // لون ثابت: أبيض شفاف (يمكنك تغيير هذا اللون)
        borderRadius: BorderRadius.circular(borderRadius), // يجب إضافة borderRadius هنا
        border: Border.all(
          color: Colors.white.withOpacity(0.5), 
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}