import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/pages/many_to_many_call_page.dart';
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
            color: const Color(0xFF444444),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(
        top: 45,
        bottom: 100,
      ),
      color: const Color(0xFF222222),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: _getCards(),
      ),
    );
  }
}
