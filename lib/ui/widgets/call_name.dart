import 'package:flutter/material.dart';

class CallName extends StatelessWidget {
  const CallName({
    Key? key,
    required this.callName,
  }) : super(key: key);

  final String callName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            callName,
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
