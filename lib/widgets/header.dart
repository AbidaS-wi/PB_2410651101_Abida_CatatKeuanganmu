import 'package:flutter/material.dart';
import '../core/constants.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.sub, required this.title});

  final String sub;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sub,
            style: const TextStyle(
              color: kMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: kInk,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}