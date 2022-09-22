import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/utils/size_helper.dart';

/// Get the size for the Texture renderer.
Size getVideoCardSize({
  required int userCount,
  required Size screenSize,
}) {
  if (userCount == 1) {
    return Size(
      (screenSize.width - 30),
      (screenSize.height - SizeHelper.rowViewBottomPadding - SizeHelper.rowViewTopPadding),
    );
  }

  if (userCount == 2) {
    return Size(
      (screenSize.width - 30),
      (screenSize.height - SizeHelper.rowViewBottomPadding - SizeHelper.rowViewTopPadding),
    );
  }

  if (userCount >= 3 && userCount <= 4) {
    return Size(
      (screenSize.width - 30 - 10) / 2,
      (screenSize.height - SizeHelper.rowViewBottomPadding - SizeHelper.rowViewTopPadding - 10) / 2.4,
    );
  }

  if (userCount > 4) {
    return Size(
      (screenSize.width - 30 - 10) / 2,
      (screenSize.height - SizeHelper.rowViewBottomPadding - SizeHelper.rowViewTopPadding - 20) / 3,
    );
  }

  return Size(
    (screenSize.width - 30),
    (screenSize.height - SizeHelper.rowViewBottomPadding - SizeHelper.rowViewTopPadding - 10) / 2,
  );
}
