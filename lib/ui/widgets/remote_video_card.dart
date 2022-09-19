import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_disabled.dart';

class RemoteVideoCard extends StatelessWidget {
  const RemoteVideoCard({
    Key? key,
    required this.textureSize,
    required this.videoModel,
    this.isSmall = false,
  }) : super(key: key);

  final Size textureSize;
  final VideoModel videoModel;
  final bool isSmall;

  dynamic _getBody() {
    if (videoModel.texture != null) {
      return videoModel.texture;
    }

    return RemoteVideoDisabled(
      size: textureSize,
      videoModel: videoModel,
      isSmall: isSmall,
    );
  }

  Widget _showHideMicIcon() {
    if (videoModel.micEnabled) {
      return Positioned(
        top: 10,
        right: 10,
        child: Container(
          padding: isSmall ? const EdgeInsets.all(3) : const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Icon(
            Icons.mic_off,
            color: Colors.white,
            size: isSmall ? 14 : 19,
          ),
        ),
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SizedBox(
            width: textureSize.width,
            height: textureSize.height,
            child: _getBody(),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isSmall ? (textureSize.width / 3.5) - 20 : textureSize.width - 20,
              ),
              child: Text(
                videoModel.stream.user.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _showHideMicIcon(),
        ],
      ),
    );
  }
}
