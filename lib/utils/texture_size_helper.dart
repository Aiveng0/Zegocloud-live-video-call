import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/utils/size_helper.dart';

/// Get the size for the Texture renderer.
Size getVideoCardSize({
  required int userCount,
  required Size screenSize,
  bool isFullScreen = false,
}) {
  final double rowViewTopPadding = SizeHelper.rowViewTopPadding(isFullScreen: isFullScreen);
  final double rowViewBottomPadding = SizeHelper.rowViewBottomPadding(isFullScreen: isFullScreen);

  if (userCount == 1) {
    return Size(
      (screenSize.width - 30),
      (screenSize.height - rowViewBottomPadding - rowViewTopPadding),
    );
  }

  if (userCount == 2) {
    return Size(
      (screenSize.width - 30),
      (screenSize.height - rowViewBottomPadding - rowViewTopPadding),
    );
  }

  if (userCount >= 3 && userCount <= 4) {
    return Size(
      (screenSize.width - 30 - 10) / 2,
      (screenSize.height - rowViewBottomPadding - rowViewTopPadding - 10) / 2.4,
    );
  }

  if (userCount > 4) {
    return Size(
      (screenSize.width - 30 - 10) / 2,
      (screenSize.height - rowViewBottomPadding - rowViewTopPadding - 20) / 3,
    );
  }

  return Size(
    (screenSize.width - 30),
    (screenSize.height - rowViewBottomPadding - rowViewTopPadding - 10) / 2,
  );
}
