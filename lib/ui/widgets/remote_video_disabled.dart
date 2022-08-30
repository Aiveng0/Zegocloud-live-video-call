import 'package:flutter/material.dart';

class RemoteVideoDisabled extends StatelessWidget {
  const RemoteVideoDisabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF444444),
      child: const Icon(
        Icons.account_circle,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}