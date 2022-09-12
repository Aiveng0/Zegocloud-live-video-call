import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/pages/many_to_many_call_page.dart';

class RemoteVideoDisabled extends StatelessWidget {
  const RemoteVideoDisabled({
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
          color: const Color(0xFF3c4043),
          child: const Icon(
            Icons.account_circle,
            size: 60,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
