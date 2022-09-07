import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/pages/many_to_many_call_page.dart';

class LocalVideoDisabled extends StatelessWidget {
  const LocalVideoDisabled({
    Key? key,
    required this.size,
    required this.videoModel,
  }) : super(key: key);

  final Size size;
  final VideoModel videoModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          color: const Color(0xFF444444),
          child: const Icon(
            Icons.videocam_off,
            size: 40,
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black45,
            ),
            child: Text(
              videoModel.stream.user.userName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
