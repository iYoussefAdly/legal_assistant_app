import 'package:flutter/material.dart';

class ContainerChat extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool withBorder;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap; // أضفنا onTap

  const ContainerChat({
    super.key,
    this.height,
    this.width,
    required this.child,
    required this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.withBorder = true,
    this.padding,
    this.onTap, // أضفنا onTap هنا
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(borderRadius),
        border: withBorder
            ? Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.5),
                width: 1.5,
              )
            : null,
      ),
      child: child,
    );

    // إذا كان هناك onTap، ضع Container داخل GestureDetector
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}