import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImagePost extends StatelessWidget {
  final String text;
  final String url;
  const ImagePost({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.green.shade100,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(text),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
