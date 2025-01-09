import 'package:flutter/material.dart';

class ItemRowWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const ItemRowWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyMedium;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: bodyTextStyle?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          ":",
          style: bodyTextStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox.square(dimension: 4),
        Expanded(
          flex: 2,
          child: Text(
            subtitle,
            style: bodyTextStyle,
          ),
        ),
      ],
    );
  }
}
