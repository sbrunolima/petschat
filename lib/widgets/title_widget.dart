import 'package:flutter/material.dart';

Widget titleWidget() {
  return Column(
    children: [
      const Text(
        'Pets Chat',
        style: TextStyle(
            color: Colors.white, fontSize: 35, fontWeight: FontWeight.w600),
      ),
      Image.asset(
        'assets/icon02.png',
        scale: 2.5,
      ),
    ],
  );
}
