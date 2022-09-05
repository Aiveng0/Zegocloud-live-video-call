import 'package:flutter/material.dart';

class LocalVideoDisabled extends StatelessWidget {
  const LocalVideoDisabled({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: const Color(0xFF444444),
      child: const Icon(
        Icons.videocam_off,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
