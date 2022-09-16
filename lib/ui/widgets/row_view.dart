import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/ui/widgets/face_to_face_view.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_card.dart';

class RowView extends StatelessWidget {
  const RowView({
    Key? key,
    required this.videoModels,
    required this.textureSize,
  }) : super(key: key);

  final List<VideoModel> videoModels;
  final Size textureSize;

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
        padding: const EdgeInsets.only(
          top: 45,
          bottom: 100,
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
          screenSize: MediaQuery.of(context).size,
        ),
      );
    }
    
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(
        top: 45,
        bottom: 100,
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
