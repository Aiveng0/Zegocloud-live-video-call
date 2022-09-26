import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/utils/size_helper.dart';

/// You can put a card with your video in the corners of the screen.
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

  /// - 1 - top left
  /// - 2 - top right
  /// - 3 - bottom right (default)
  /// - 4 - bottom left
  int corner = 3;

  late Size localViewSize = Size(
    (widget.screenSize.width - 30) / 3.5,
    (widget.screenSize.height - rowViewTopPadding - rowViewBottomPadding) / 3.5,
  );

  late Offset topLeft = const Offset(
    10,
    10,
  );

  late Offset topRight = Offset(
    widget.screenSize.width - 30 - 10 - localViewSize.width,
    10,
  );

  late Offset bottomLeft = Offset(
    10,
    widget.screenSize.height - rowViewTopPadding - rowViewBottomPadding - 10 - localViewSize.height,
  );

  late Offset bottomRight = Offset(
    widget.screenSize.width - 30 - 10 - localViewSize.width,
    widget.screenSize.height - rowViewTopPadding - rowViewBottomPadding - 10 - localViewSize.height,
  );

  late Offset localViewOffset = bottomRight;

  void case1(double dx, double dy) {
    if (dx > 10) {
      setState(() {
        corner = 2;
        localViewOffset = topRight;
      });
    }

    if (dy > 10) {
      setState(() {
        corner = 4;
        localViewOffset = bottomLeft;
      });
    }
  }

  void case2(double dx, double dy) {
    if (dy > 10) {
      setState(() {
        corner = 3;
        localViewOffset = bottomRight;
      });
    }

    if (dx < -10) {
      setState(() {
        corner = 1;
        localViewOffset = topLeft;
      });
    }
  }

  void case3(double dx, double dy) {
    if (dx < -10) {
      setState(() {
        corner = 4;
        localViewOffset = bottomLeft;
      });
    }

    if (dy < -10) {
      setState(() {
        corner = 2;
        localViewOffset = topRight;
      });
    }
  }

  void case4(double dx, double dy) {
    if (dx > 10) {
      setState(() {
        corner = 3;
        localViewOffset = bottomRight;
      });
    }

    if (dy < -10) {
      setState(() {
        corner = 1;
        localViewOffset = topLeft;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.remoteView,
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          left: localViewOffset.dx,
          top: localViewOffset.dy,
          child: ClipRRect(
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
              child: GestureDetector(
                onPanUpdate: (details) {
                  double dx = details.delta.dx;
                  double dy = details.delta.dy;

                  if (dx > 10 || dx < -10 || dy > 10 || dy < -10) {
                    switch (corner) {
                      case 1:
                        case1(dx, dy);
                        break;
                      case 2:
                        case2(dx, dy);
                        break;
                      case 3:
                        case3(dx, dy);
                        break;
                      case 4:
                        case4(dx, dy);
                        break;
                    }
                  }
                },
                child: Material(
                  child: widget.localView,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
