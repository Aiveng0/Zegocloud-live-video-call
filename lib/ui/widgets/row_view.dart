import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_card.dart';

class RowView extends StatelessWidget {
  const RowView({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      color: const Color(0xFF222222),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          list.length,
          (index) => RemoteVideoCard(
            textureWidget: list[index],
          ),
        ),
      ),
    );
  }
}
