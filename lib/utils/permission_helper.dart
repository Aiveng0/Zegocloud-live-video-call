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
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      log(name: 'PermissionHelper', 'Error: Microphone permission not granted!');
    }
  }

  /// Request the user for access to camera permission, if access hasn't already been grant access before.
  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      log(name: 'PermissionHelper', 'Error: Camera permission not granted!');
    }
  }
}
