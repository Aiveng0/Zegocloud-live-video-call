import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';

class RemoteVideoDisabled extends StatelessWidget {
  const RemoteVideoDisabled({
    Key? key,
    required this.size,
    required this.videoModel,
    this.isSmall = false,
  }) : super(key: key);

  final Size size;
  final VideoModel videoModel;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          color: const Color(0xFF3c4043),
          child: Icon(
            Icons.account_circle,
            size: isSmall ? 40 : 60,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
