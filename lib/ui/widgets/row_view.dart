import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/ui/widgets/face_to_face_view.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_card.dart';
import 'package:zegocloud_live_video_call/utils/size_helper.dart';

class RowView extends StatelessWidget {
  const RowView({
    Key? key,
    required this.videoModels,
    required this.textureSize,
    this.isFullScreen = false,
  }) : super(key: key);

  final List<VideoModel> videoModels;
  final Size textureSize;
  final bool isFullScreen;

  List<Widget> _getCards() {
    List<Widget> list = [];

    if (videoModels.length > 6) {
      list = List.generate(
        5,
        (index) {
          return RemoteVideoCard(
            textureSize: textureSize,
            videoModel: videoModels[index],
          );
        },
      );

      list.add(
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF3c4043),
          ),
          width: textureSize.width,
          height: textureSize.height,
          child: Text(
            '+${videoModels.length - 5}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
            ),
          ),
        ),
      );

      return list;
    }

    list = List.generate(
      videoModels.length,
      (index) {
        return RemoteVideoCard(
          textureSize: textureSize,
          videoModel: videoModels[index],
        );
      },
    );

    return list;
  }

  Widget _setGridView(BuildContext context) {
    if (videoModels.length == 2) {
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFF202124),
        padding: EdgeInsets.only(
          top: SizeHelper.rowViewTopPadding(isFullScreen: isFullScreen),
          bottom: SizeHelper.rowViewBottomPadding(isFullScreen: isFullScreen),
          left: 15,
          right: 15,
        ),
        child: FaceToFaceView(
          localView: RemoteVideoCard(
            textureSize: textureSize,
            videoModel: videoModels[0],
            isSmall: true,
          ),
          remoteView: RemoteVideoCard(
            textureSize: textureSize,
            videoModel: videoModels[1],
          ),
          textureSize: textureSize,
          localViewSize: Size(
            textureSize.width / 3.5,
            textureSize.height / 3.5,
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(
        top: SizeHelper.rowViewTopPadding(isFullScreen: isFullScreen),
        bottom: SizeHelper.rowViewBottomPadding(isFullScreen: isFullScreen),
      ),
      color: const Color(0xFF202124),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: _getCards(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _setGridView(context);
  }
}
