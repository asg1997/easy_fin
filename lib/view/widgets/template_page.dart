import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key, required this.child, required this.title});
  final Widget child;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ).copyWith(top: 30, bottom: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(color: Colors.grey.withValues(alpha: .5), thickness: .5),
        Gap(20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: child,
          ),
        ),
      ],
    );
  }
}
