import 'package:flutter/material.dart';
import 'package:zegocloud_live_video_call/ui/widgets/call_name.dart';
import 'package:zegocloud_live_video_call/ui/widgets/online_users_counter.dart';

class CallAppBar extends StatefulWidget {
  const CallAppBar({
    super.key,
    required this.onlineUsersCount,
    required this.callEndButtonPressed,
    this.onCallNameTap,
  });

  final int onlineUsersCount;
  final VoidCallback? onCallNameTap;
  final VoidCallback callEndButtonPressed;

  @override
  State<CallAppBar> createState() => _CallAppBarState();
}

class _CallAppBarState extends State<CallAppBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 25,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 30 - 25,
        height: 40,
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
                child: const CallName(
                  name: 'Some call name onlineUsersCount: widget.onlineUsersCount',
                ),
              ),
            ),
            const Spacer(),
            OnlineUsersCounter(
              onlineUsersCount: widget.onlineUsersCount,
            ),
          ],
        ),
      ),
    );
  }
}
