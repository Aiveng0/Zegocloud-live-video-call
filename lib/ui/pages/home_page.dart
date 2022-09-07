// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zegocloud_live_video_call/ui/pages/many_to_many_call_page.dart';
import 'package:zegocloud_live_video_call/utils/settings.dart' as settings;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _userIDController = TextEditingController(text: '1234');
  final TextEditingController _roomIDController = TextEditingController(text: '1111');
  final TextEditingController _tokenController = TextEditingController(text: settings.token);
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _userIDController.dispose();
    _roomIDController.dispose();
    _tokenController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> requestPermission() async {
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus != PermissionStatus.granted) {
      log('Error: Microphone permission not granted!!!');
    }

    PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      log('Error: Camera permission not granted!!!');
    }
  }

  void _unfocus(BuildContext context) {
    final FocusScopeNode focus = FocusScope.of(context);
    if (focus.hasFocus) {
      focus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => _unfocus(context),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'ZEGOCLOUD',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _userIDController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                    hintText: 'User ID',
                    labelText: 'User ID',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _roomIDController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                    hintText: 'Room ID',
                    labelText: 'Room ID',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                    hintText: 'Username',
                    labelText: 'Username',
                  ),
                  maxLength: 30,
                ),
                const SizedBox(height: 20),
                IgnorePointer(
                  ignoring: true,
                  child: TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                        ),
                      ),
                      hintText: 'User token',
                      labelText: 'User token',
                    ),
                    style: const TextStyle(
                      color: Colors.black38,
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _userIDController.text = '1234';
                        _tokenController.text =
                            '03AAAFgIv2DRgAEDlhM3dvMjZzc294Z2ZwZGcAoGJfBSXdpDdRTJuu4WYcfRwoPyuMQJ/qgrEC35wny+SS0iKyf0uw952DZrl5w1sA7hrunqOaXmD7qf7sdEdRG4jQI3f+tLjHyF70dIS9voneUXhAKhEP8pRAZIMuJTJvSCc5Pnt4AdOwcm6kSsJivUI49bxdH7w0/DWqO90S9omr0a6RqN1ZeD/Rv+rkdgp7i6Nit6A7cxUP8i/VJm7Y550=';
                      },
                      child: const Text('User 1234 (default)'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _userIDController.text = '1111';
                        _tokenController.text =
                            '03AAAFgIv2Db4AEHp3ZmswbDhrbWlxMWhrOWgAoLZdgC2GhBcgr2c4wJe9Y4mkwEex1NUvRhguotzAXmGTRC0J9+RYtMdAgDauDQsxtFmLf1fcQwBStBky72tFBjsU6V3eIcEjGac0qn97lh3ICcIcUtFNqdX5y6KfI3kCZ/gcgz7R3MEqvGqdltjZUMTcCtrYo1/uug0YVU3e5qosAltKNC6VTSF8W4ZPVaBk99pjr07ljFTD49P+BNkBQTs=';
                      },
                      child: const Text('User 1111'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _userIDController.text = '2222';
                        _tokenController.text =
                            '03AAAFgIv2DegAEDQ2aHFjMXl0Y2Y1cmwxdGIAoP0OMgXKUaDBLs4XqRRX6DIHPiTOoKbtwyTi9Y4BO9gU/1WZFOUu4SXF1tLDoAtGG/of9vpxz/I+hafJasO7FLeQHs+EsLYWFUSaDxv/max29EPHoSYFSYAvzE93pc5z5gDBN5OSMgLWotKBooNF7L5PsxjVnedTevjqBQeu/bHhnbYWpj7cv2zwlMFWEKuOCaBlNzHLO1lOMV7OlmktJ5A=';
                      },
                      child: const Text('User 2222'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _userIDController.text = '3333';
                        _tokenController.text =
                            '03AAAFgIv8o1sAEHE0cHI5MG80b2hvZ3VtaGcAoBAYRod1k063/0fVkzFJLbfT7sur97BB0Zu1YEVKP1BE77b32wAcF74fqEpbZtFIZ0NDRvjpnp7/6m+okcCgpEUmpnuVvLU0WltK3c2OgoEu6eCp33qJMcG45MvIgxkp7gjlWCCbqldKQQMnoYl+V/aP7+C0Gf1w3o+uRd5qPQw+QK2U/x9OE2VbcXeqmyCGqNJwdh/3u4BZ2RBB9zL9DJA=';
                      },
                      child: const Text('User 3333'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _userIDController.text = '4444';
                        _tokenController.text =
                            '03AAAFgIv8o2cAEGd2YmI2czVtcjU2MXhhemoAoBNQB4fUO4LxQ7daF4IKj8oLEPp17v3ATP1c2sdOxqgpRoxsVMFhRmd9kiZ1Xw6PsHBsdDgmv55i1In+y9TpIykITxjZeoVSilI+TY17JjRCHcoJHm1duQMT66Exls+0XnLeYdkGRAfyyV8gStNoL59BsTFlIvJdsoo+vcEFnlSRSGcc46brfTMA+mB+4ISninMbqOVLkV2fGRkU+uDqMsA=';
                      },
                      child: const Text('User 4444'),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () async {
                    await requestPermission();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManyToManyCallPage(
                          userID: _userIDController.text,
                          roomID: _roomIDController.text,
                          appSign: null,
                          appID: settings.appID,
                          token: _tokenController.text,
                          username: _usernameController.text,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Start Video Call',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
