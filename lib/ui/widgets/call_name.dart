import 'package:flutter/material.dart';

class CallName extends StatelessWidget {
  const CallName({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(
          Icons.arrow_right,
          color: Colors.white,
        ),
      ],
    );
  }
}
