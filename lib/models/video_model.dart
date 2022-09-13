import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

/// Video model.
///
/// - [stream] - ZegoStream object.
/// - [viewID] - The identity of the backend texture.
/// - [texture] - [Texture] widget identified by [viewID] (textureId).
/// - [micEnabled] - State of the user's microphone (true/false).
/// The default value is [true] because when you join a room, the [onRemoteMicStateUpdate] callback does not work with the [ZegoRemoteDeviceState.Open] event.
class VideoModel {
  VideoModel({
    required this.stream,
    this.viewID,
    this.texture,
    this.micEnabled = true,
  });
  ZegoStream stream;
  int? viewID;
  Texture? texture;
  bool micEnabled;
}