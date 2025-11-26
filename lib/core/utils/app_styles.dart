import 'package:flutter/material.dart';

abstract class AppStyles {
  static const styleBold24 = TextStyle(
    fontFamily: "Inter",
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xff544F4F)
  );
  static const styleRegular20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Color(0xff544F4F)
  );
  static const styleRegular16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const styleRegular14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const styleRegular12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const styleRegular18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static const styleSemitBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white
  );
  static const styleSemitBold14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const styleMedium14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
