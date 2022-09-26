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
    required this.cameraButtonPressed,
    required this.switchCameraButtonPressed,
    this.hideControlElements = false,
  }) : super(key: key);

  final bool micEnabled;
  final bool cameraEnabled;
  final bool hideControlElements;
  final void Function()? micButtonPressed;
  final void Function()? callEndButtonPressed;
  final void Function()? cameraButtonPressed;
  final void Function()? switchCameraButtonPressed;

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 200),
      bottom: widget.hideControlElements ? -82 : 25,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToolbarButton(
            onPressed: widget.callEndButtonPressed,
            icon: Icons.call_end,
            iconSize: 32,
            color: const Color(0xFFea4335),
          ),
          ToolbarButton(
            onPressed: widget.micButtonPressed,
            icon: widget.micEnabled ? Icons.mic : Icons.mic_off,
            color: widget.micEnabled ? const Color(0xFF3c4043) : Colors.white,
            iconColor: widget.micEnabled ? Colors.white : const Color(0xFF3c4043),
          ),
          ToolbarButton(
            onPressed: widget.cameraButtonPressed,
            icon: widget.cameraEnabled ? Icons.videocam : Icons.videocam_off,
            color: widget.cameraEnabled ? const Color(0xFF3c4043) : Colors.white,
            iconColor: widget.cameraEnabled ? Colors.white : const Color(0xFF3c4043),
          ),
          ToolbarButton(
            onPressed: widget.switchCameraButtonPressed,
            icon: Icons.switch_camera,
          ),
        ],
      ),
    );
  }
}

class ToolbarButton extends StatefulWidget {
  const ToolbarButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.color,
    this.iconColor,
    this.iconSize,
    this.padding = 10.0,
  }) : super(key: key);

  final void Function()? onPressed;
  final Color? color;
  final Color? iconColor;
  final IconData icon;
  final double? iconSize;
  final double padding;

  @override
  State<ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<ToolbarButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(widget.padding),
        backgroundColor: widget.color ?? const Color(0xFF3c4043),
      ),
      onPressed: widget.onPressed,
      child: Icon(
        widget.icon,
        size: widget.iconSize,
        color: widget.iconColor ?? Colors.white,
      ),
    );
  }
}
