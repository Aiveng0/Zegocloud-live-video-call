import 'package:flutter/material.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({
    Key? key,
    required this.micEnabled,
    required this.cameraEnabled,
    required this.micButtonPressed,
    required this.callEndButtonPressed,
    required this.enableCameraButtonPressed,
    required this.switchCameraButtonPressed,
  }) : super(key: key);

  final bool micEnabled;
  final bool cameraEnabled;
  final void Function()? micButtonPressed;
  final void Function()? callEndButtonPressed;
  final void Function()? enableCameraButtonPressed;
  final void Function()? switchCameraButtonPressed;

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              primary: Colors.blueAccent,
            ),
            onPressed: widget.micButtonPressed,
            child: Icon(
              widget.micEnabled ? Icons.mic : Icons.mic_off,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              primary: Colors.red,
            ),
            onPressed: widget.callEndButtonPressed,
            child: const Icon(
              Icons.call_end,
              size: 32,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              primary: Colors.blueAccent,
            ),
            onPressed: widget.enableCameraButtonPressed,
            child: Icon(
              widget.cameraEnabled ? Icons.videocam : Icons.videocam_off,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              primary: Colors.blueAccent,
            ),
            onPressed: widget.switchCameraButtonPressed,
            child: const Icon(
              Icons.switch_camera,
            ),
          ),
        ],
      ),
    );
  }
}
