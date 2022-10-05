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
          child: Center(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: videoModel.avatarColor,
              ),
              width: 60,
              height: 60,
              child: Text(
                videoModel.stream.user.userName[0],
                style: const TextStyle(
                  fontSize: 38,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
