import 'package:flutter/material.dart';

/// Get the size for the Texture renderer.
Size getVideoCardSize({
  required int userCount,
  required Size screenSize,
}) {
  if (userCount == 1) {
    return Size(
      (screenSize.width - 30),
      (screenSize.height - 100 - 45),
    );
  }

  if (userCount == 2) {
    return Size(
      (screenSize.width - 30),
      (screenSize.height - 100 - 45),
    );
  }

  if (userCount >= 3 && userCount <= 4) {
    return Size(
      (screenSize.width - 30 - 10) / 2,
      (screenSize.height - 100 - 45 - 10) / 2.4,
    );
  }

  if (userCount > 4) {
    return Size(
      (screenSize.width - 30 - 10) / 2,
      (screenSize.height - 100 - 45 - 20) / 3,
    );
  }

  return Size(
    (screenSize.width - 30),
    (screenSize.height - 100 - 45 - 10) / 2,
  );
}
