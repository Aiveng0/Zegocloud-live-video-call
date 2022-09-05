import 'package:flutter/material.dart';

class RemoteVideoDisabled extends StatelessWidget {
  const RemoteVideoDisabled({
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
        Icons.account_circle,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}
