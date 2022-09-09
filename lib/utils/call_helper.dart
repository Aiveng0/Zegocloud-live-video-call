import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zegocloud_live_video_call/utils/texture_size_helper.dart';

class CallHelper {
  /// Update the size of the Texture renderer.
  Future<void> updateTexturesSize({
    required BuildContext context,
    required int onlineUsersCount,
    required List<int> remoteViewIDs,
    required int localViewID,
  }) async {
    final Size size = getVideoCardSize(
      screenSize: MediaQuery.of(context).size,
      userCount: onlineUsersCount,
    );

    log('updateTextureRendererSize START');

    for (var viewID in remoteViewIDs) {
      await ZegoExpressEngine.instance.updateTextureRendererSize(
        viewID,
        size.width.toInt(),
        size.height.toInt(),
      );
    }

    await ZegoExpressEngine.instance.updateTextureRendererSize(
      localViewID,
      size.width.toInt(),
      size.height.toInt(),
    );

    log('updateTextureRendererSize END');
  }
}
