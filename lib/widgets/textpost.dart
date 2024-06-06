import 'package:flutter/material.dart';

class TextPost extends StatelessWidget {
  final String text;
  const TextPost({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.green.shade100),
      padding: const EdgeInsets.all(12),
      child: Text(text),
    );
  }
}
