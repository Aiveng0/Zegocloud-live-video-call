import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/utils/size_helper.dart';

/// DEPRECATED! (old version)
///
/// You can place a card with your video anywhere on the screen.
class FaceToFaceView2 extends StatefulWidget {
  const FaceToFaceView2({
    Key? key,
    required this.remoteView,
    required this.localView,
    required this.screenSize,
  }) : super(key: key);

  final Widget remoteView;
  final Widget localView;
  final Size screenSize;

  @override
  State<FaceToFaceView2> createState() => _FaceToFaceViewState();
}

class _FaceToFaceViewState extends State<FaceToFaceView2> {
  final rowViewTopPadding = SizeHelper.rowViewTopPadding();
  final rowViewBottomPadding = SizeHelper.rowViewBottomPadding();

  late Size localViewSize = Size(
    (widget.screenSize.width - 30) / 3.5,
    (widget.screenSize.height - rowViewTopPadding - rowViewBottomPadding) / 3.5,
  );

  late Offset localViewOffset = Offset(
    widget.screenSize.width - 30 - 10 - localViewSize.width,
    widget.screenSize.height - rowViewTopPadding - rowViewBottomPadding - 10 - localViewSize.height,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.remoteView,
        ),
        Positioned(
          left: localViewOffset.dx,
          top: localViewOffset.dy,
          child: Draggable<Widget>(
            onDragEnd: (details) {
              final Size size = widget.screenSize;
              double dx = details.offset.dx;
              double dy = details.offset.dy + 25; //dy += 25, IDK why

              if (details.offset.dx < 15) dx = 15;
              if (details.offset.dx > size.width - 15 - localViewSize.width) {
                dx = size.width - 15 - localViewSize.width;
              }
              if (details.offset.dy < rowViewBottomPadding) dy = rowViewBottomPadding;
              if (details.offset.dy > size.height - rowViewTopPadding - localViewSize.height - 25) {
                dy = size.height - rowViewTopPadding - localViewSize.height;
              }

              setState(() => localViewOffset = Offset(dx - 15, dy - rowViewBottomPadding));
            },
            childWhenDragging: Container(),
            feedback: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: localViewSize.width,
                height: localViewSize.height,
                child: Material(
                  child: widget.localView,
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              width: localViewSize.width,
              height: localViewSize.height,
              child: widget.localView,
            ),
          ),
        ),
      ],
    );
  }
}
