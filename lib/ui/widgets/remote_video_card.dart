import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/widgets/remote_video_disabled.dart';

class RemoteVideoCard extends StatefulWidget {
  const RemoteVideoCard({
    Key? key,
    required this.textureWidget,
  }) : super(key: key);

  final Widget? textureWidget;
  // final int streamID;

  @override
  State<RemoteVideoCard> createState() => _RemoteVideoEnabledState();
}

class _RemoteVideoEnabledState extends State<RemoteVideoCard> {
  Widget _getPlayViewWidget(Widget? textureWidget) {
    if (textureWidget != null) {
      return textureWidget;
    }

    return const RemoteVideoDisabled();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 40 - 20) / 3,
      height: (MediaQuery.of(context).size.height - 80 - 40) / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _getPlayViewWidget(
          widget.textureWidget,
        ),
      ),
    );
  }
}
