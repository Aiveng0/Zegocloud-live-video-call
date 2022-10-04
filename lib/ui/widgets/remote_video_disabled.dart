import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/utils/color_helper.dart';

class RemoteVideoDisabled extends StatefulWidget {
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
  State<RemoteVideoDisabled> createState() => _RemoteVideoDisabledState();
}

class _RemoteVideoDisabledState extends State<RemoteVideoDisabled> {
  late MaterialColor color;

  @override
  void initState() {
    color = ColorHelper.getRandomColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.size.width,
          height: widget.size.height,
          color: const Color(0xFF3c4043),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              width: 60,
              height: 60,
              child: Text(
                widget.videoModel.stream.user.userName[0],
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
