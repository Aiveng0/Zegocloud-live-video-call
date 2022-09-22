import 'package:flutter/material.dart';

class OnlineUsersCounter extends StatelessWidget {
  const OnlineUsersCounter({
    Key? key,
    required this.onlineUsersCount,
  }) : super(key: key);

  final int onlineUsersCount;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          const Icon(
            Icons.account_box,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            onlineUsersCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
