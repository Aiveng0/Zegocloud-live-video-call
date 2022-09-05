import 'package:flutter/material.dart';

class RemoteVideoCard extends StatelessWidget {
  const RemoteVideoCard({
    Key? key,
    required this.textureWidget,
    required this.textureSize,
  }) : super(key: key);

  final Widget textureWidget;
  final Size textureSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.grey,
        width: textureSize.width,
        height: textureSize.height,
        child: textureWidget,
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double rt = height - width;
    Path path = Path();

    path.moveTo(0, height - width);
    path.lineTo(width - rt, height - width);
    path.lineTo(width - rt, width);
    path.lineTo(0, width);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
