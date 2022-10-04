import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/widgets/call_name.dart';
import 'package:zegocloud_live_video_call/ui/widgets/online_users_counter.dart';

class CallAppBar extends StatefulWidget {
  const CallAppBar({
    Key? key,
    required this.onlineUsersCount,
    required this.callEndButtonPressed,
    required this.callName,
    this.onCallNameTap,
    this.hideControlElements = false,
  }) : super(key: key);

  final int onlineUsersCount;
  final bool hideControlElements;
  final VoidCallback? onCallNameTap;
  final VoidCallback callEndButtonPressed;
  final String callName;

  @override
  State<CallAppBar> createState() => _CallAppBarState();
}

class _CallAppBarState extends State<CallAppBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 25,
      curve: Curves.easeInOut,
      top: widget.hideControlElements ? -40 : 30,
      duration: const Duration(milliseconds: 200),
      height: widget.hideControlElements ? 0 : 40,
      width: MediaQuery.of(context).size.width - 30 - 25,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              widget.callEndButtonPressed();
              Navigator.pop(context, true);
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: InkWell(
              onTap: widget.onCallNameTap,
              child: CallName(
                callName: widget.callName,
              ),
            ),
          ),
          const Spacer(),
          OnlineUsersCounter(
            onlineUsersCount: widget.onlineUsersCount,
          ),
        ],
      ),
    );
  }
}
