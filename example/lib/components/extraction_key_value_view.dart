import 'package:flutter/material.dart';

class ExtractionKeyValueView extends StatelessWidget {
  final String title;
  final Widget child;

  const ExtractionKeyValueView(
      {required this.title, required this.child, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(
          width: 10,
        ),
        child,
      ],
    );
  }
}
