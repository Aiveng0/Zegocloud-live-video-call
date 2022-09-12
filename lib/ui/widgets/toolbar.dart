import 'package:flutter/material.dart';

class Toolbar extends StatefulWidget {
  /// Row with control buttons:
  ///
  /// Turn on/off the microphone, turn on/off the camera, switch the camera, exit the call.
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
          _ToolbarButton(
            onPressed: widget.micButtonPressed,
            icon: widget.micEnabled ? Icons.mic : Icons.mic_off,
            color: widget.micEnabled ? const Color(0xFF3c4043) : const Color(0xFFea4335),
          ),
          _ToolbarButton(
            onPressed: widget.callEndButtonPressed,
            icon: Icons.call_end,
            iconSize: 32,
            color: const Color(0xFFea4335),
          ),
          _ToolbarButton(
            onPressed: widget.enableCameraButtonPressed,
            icon: widget.cameraEnabled ? Icons.videocam : Icons.videocam_off,
            color: widget.cameraEnabled ? const Color(0xFF3c4043) : const Color(0xFFea4335),
          ),
          _ToolbarButton(
            onPressed: widget.switchCameraButtonPressed,
            icon: Icons.switch_camera,
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatefulWidget {
  const _ToolbarButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.color,
    this.iconSize,
  }) : super(key: key);

  final void Function()? onPressed;
  final Color? color;
  final IconData icon;
  final double? iconSize;

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        backgroundColor: widget.color ?? const Color(0xFF3c4043),
      ),
      onPressed: widget.onPressed,
      child: Icon(
        widget.icon,
        size: widget.iconSize,
      ),
    );
  }
}
