import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

/// Video model.
///
/// - [stream] - ZegoStream object.
/// - [viewID] - The identity of the backend texture.
/// - [texture] - [Texture] widget identified by [viewID] (textureId).
/// - [micEnabled] - State of the user's microphone (true/false).
/// The default value is [true] because when you join a room, the [onRemoteMicStateUpdate] callback does not work with the [ZegoRemoteDeviceState.Open] event.
/// - [soundLevel] Remote sound level value. Value ranging from 0.0 to 100.0.
class VideoModel {
  VideoModel({
    required this.stream,
    this.viewID,
    this.texture,
    this.micEnabled = true,
    this.soundLevel = 0.0,
  });
  ZegoStream stream;
  int? viewID;
  Texture? texture;
  bool micEnabled;
  double soundLevel;
}
