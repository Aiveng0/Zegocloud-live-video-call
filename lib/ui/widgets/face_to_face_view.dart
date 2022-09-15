import 'package:flutter/material.dart';

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
  late Size localViewSize = Size(
    (widget.screenSize.width - 30) / 3.5,
    (widget.screenSize.height - 100 - 45) / 3.5,
  );

  late Offset localViewOffset = Offset(
    widget.screenSize.width - 30 - 10 - localViewSize.width,
    widget.screenSize.height - 100 - 45 - 10 - localViewSize.height,
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

              // 15 => left and right padding
              if (details.offset.dx < 15) dx = 15;
              if (details.offset.dx > size.width - 15 - localViewSize.width) {
                dx = size.width - 15 - localViewSize.width;
              }
              // 45 => top padding
              // 100 => bottom padding
              if (details.offset.dy < 45) dy = 45;
              if (details.offset.dy > size.height - 100 - localViewSize.height) {
                dy = size.height - 100 - localViewSize.height;
              }

              setState(() => localViewOffset = Offset(dx - 15, dy - 45));
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
