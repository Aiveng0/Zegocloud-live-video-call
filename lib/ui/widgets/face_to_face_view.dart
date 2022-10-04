import 'package:flutter/material.dart';

/// You can put a card with your video in the corners of the screen.
class FaceToFaceView extends StatefulWidget {
  const FaceToFaceView({
    Key? key,
    required this.remoteView,
    required this.localView,
    required this.textureSize,
    required this.localViewSize,
  }) : super(key: key);

  final Widget remoteView;
  final Widget localView;
  final Size textureSize;
  final Size localViewSize;

  @override
  State<FaceToFaceView> createState() => _FaceToFaceViewState();
}

class _FaceToFaceViewState extends State<FaceToFaceView> {
  /// - 1 - top left position.
  /// - 2 - top right position.
  /// - 3 - bottom right (default) position.
  /// - 4 - bottom left position.
  int corner = 3;

  void case1(double dx, double dy) {
    if (dx > 10) setState(() => corner = 2);
    if (dy > 10) setState(() => corner = 4);
  }

  void case2(double dx, double dy) {
    if (dy > 10) setState(() => corner = 3);
    if (dx < -10) setState(() => corner = 1);
  }

  void case3(double dx, double dy) {
    if (dx < -10) setState(() => corner = 4);
    if (dy < -10) setState(() => corner = 2);
  }

  void case4(double dx, double dy) {
    if (dx > 10) setState(() => corner = 3);
    if (dy < -10) setState(() => corner = 1);
  }

  void _onPanUpdate(DragUpdateDetails details) {
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
  }

  Alignment _getAlignment(int corner) {
    switch (corner) {
      case 1:
        return Alignment.topLeft;
      case 2:
        return Alignment.topRight;
      case 3:
        return Alignment.bottomRight;
      case 4:
        return Alignment.bottomLeft;
      default:
        return Alignment.bottomRight;
    }
  }

  EdgeInsetsGeometry _getPadding(int corner) {
    return corner != 4
        ? const EdgeInsets.all(10)
        : const EdgeInsets.only(
            left: 10,
            bottom: 35,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.remoteView,
        ),
        AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: _getPadding(corner),
          child: AnimatedAlign(
            alignment: _getAlignment(corner),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
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
                width: widget.localViewSize.width,
                height: widget.localViewSize.height,
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  child: Material(
                    child: widget.localView,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
