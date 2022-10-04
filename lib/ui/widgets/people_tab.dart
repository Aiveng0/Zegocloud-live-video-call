import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/models/video_model.dart';
import 'package:zegocloud_live_video_call/utils/color_helper.dart';

class PeopleTab extends StatelessWidget {
  const PeopleTab({
    super.key,
    this.scrollController,
    required this.videoModels,
  });

  final ScrollController? scrollController;
  final List<VideoModel> videoModels;

  List<Widget> _getUsers() {
    List<Widget> list = [];

    for (int i = 0; i < videoModels.length; i++) {
      final String name = i == 0 ? '${videoModels[i].stream.user.userName} (You)' : videoModels[i].stream.user.userName;

      list.add(
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _AvatarBox(
                name: name,
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                videoModels[i].micEnabled ? Icons.mic : Icons.mic_off,
                color: Colors.black87,
              ),
              const SizedBox(width: 10),
              Icon(
                videoModels[i].texture != null ? Icons.videocam : Icons.videocam_off,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Participants',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(15),
            controller: scrollController,
            children: _getUsers(),
          ),
        ),
      ],
    );
  }
}

class _AvatarBox extends StatefulWidget {
  const _AvatarBox({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  State<_AvatarBox> createState() => __AvatarBoxState();
}

class __AvatarBoxState extends State<_AvatarBox> {
  late MaterialColor color;
  @override
  void initState() {
    color = ColorHelper.getRandomColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 30,
      height: 30,
      child: Text(
        widget.name[0],
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
