import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/utils/size_helper.dart';

class FaceToFaceView extends StatefulWidget {
  const FaceToFaceView({
    super.key,
    required this.remoteView,
    required this.localView,
    required this.screenSize,
  });

  final Widget remoteView;
  final Widget localView;
  final Size screenSize;

  @override
  State<FaceToFaceView> createState() => _FaceToFaceViewState();
}

class _FaceToFaceViewState extends State<FaceToFaceView> {
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
              double dy = details.offset.dy;

              if (details.offset.dx < 15) dx = 15;
              if (details.offset.dx > size.width - 15 - localViewSize.width) {
                dx = size.width - 15 - localViewSize.width;
              }
              if (details.offset.dy < rowViewBottomPadding) dy = rowViewBottomPadding;
              if (details.offset.dy > size.height - rowViewTopPadding - localViewSize.height) {
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
