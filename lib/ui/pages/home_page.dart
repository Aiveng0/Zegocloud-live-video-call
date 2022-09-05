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

  @override
  void dispose() {
    _userIDController.dispose();
    _roomIDController.dispose();
    _tokenController.dispose();
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ZEGOCLOUD',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  decoration: TextDecoration.none,
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
                maxLines: null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      _userIDController.text = '1234';
                      _tokenController.text =
                          '03AAAFgIv2DRgAEDlhM3dvMjZzc294Z2ZwZGcAoGJfBSXdpDdRTJuu4WYcfRwoPyuMQJ/qgrEC35wny+SS0iKyf0uw952DZrl5w1sA7hrunqOaXmD7qf7sdEdRG4jQI3f+tLjHyF70dIS9voneUXhAKhEP8pRAZIMuJTJvSCc5Pnt4AdOwcm6kSsJivUI49bxdH7w0/DWqO90S9omr0a6RqN1ZeD/Rv+rkdgp7i6Nit6A7cxUP8i/VJm7Y550=';
                    },
                    child: const Text('User 1234'),
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
            ],
          ),
        ),
      ),
    );
  }
}
