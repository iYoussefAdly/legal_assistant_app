import 'package:flutter/material.dart';

OutlineInputBorder buildBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0xFFF6D3D3)),
  );
}

OutlineInputBorder buildErrorBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
}
