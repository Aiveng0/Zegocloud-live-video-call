import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/pages/many_to_many_call_page.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_disabled.dart';

class RemoteVideoCard extends StatelessWidget {
  const RemoteVideoCard({
    Key? key,
    required this.textureSize,
    required this.videoModel,
  }) : super(key: key);

  final Size textureSize;
  final VideoModel videoModel;

  _getBody() {
    if (videoModel.texture != null) {
      return videoModel.texture;
    }
    return RemoteVideoDisabled(
      size: textureSize,
      videoModel: videoModel,
    );
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
                maxWidth: textureSize.width - 20,
              ),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black45,
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
        ],
      ),
    );
  }
}
