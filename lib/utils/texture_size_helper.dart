import 'package:flutter/material.dart';

Size getVideoCardSize({
  required int userCount,
  required BuildContext context,
}) {
  final Size availableSize = MediaQuery.of(context).size;

  if (userCount == 1) {
    return Size(
      (availableSize.width - 30),
      (availableSize.height - 100 - 45),
    );
  }

  if (userCount >= 3 && userCount <= 4) {
    return Size(
      (availableSize.width - 30 - 10) / 2,
      (availableSize.height - 100 - 45 - 10) / 2.4,
    );
  }

  if (userCount > 4) {
    return Size(
      (availableSize.width - 30 - 10) / 2,
      (availableSize.height - 100 - 45 - 20) / 3,
    );
  }

  return Size(
    (availableSize.width - 30),
    (availableSize.height - 100 - 45 - 10) / 2,
  );
}
