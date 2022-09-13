import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Request the user for access to microphone ane camera permission, if access hasn't already been grant access before.
  Future<void> requestPermission() async {
    await requestMicPermission();
    await requestCameraPermission();
  }

  /// Request the user for access to microphone permission, if access hasn't already been grant access before.
  Future<void> requestMicPermission() async {
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus != PermissionStatus.granted) {
      log(name: 'PermissionHelper', 'Error: Microphone permission not granted!');
    }
  }

  /// Request the user for access to camera permission, if access hasn't already been grant access before.
  Future<void> requestCameraPermission() async {
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus != PermissionStatus.granted) {
      log(name: 'PermissionHelper', 'Error: Microphone permission not granted!');
    }
  }
}
