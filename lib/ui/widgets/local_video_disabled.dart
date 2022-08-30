import 'package:flutter/material.dart';

class LocalVideoDisabled extends StatelessWidget {
  const LocalVideoDisabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF444444),
      child: const Icon(
        Icons.videocam_off,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
