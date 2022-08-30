import 'package:flutter/material.dart';

class OnlineUsersCounter extends StatelessWidget {
  const OnlineUsersCounter({
    Key? key,
    required this.onlineUsersCount,
  }) : super(key: key);

  final int onlineUsersCount;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 25,
      child: Container(
        padding: const EdgeInsets.only(
          right: 4,
          top: 2,
          bottom: 2,
          left: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            4,
          ),
          color: Colors.black54,
        ),
        child: Center(
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
        ),
      ),
    );
  }
}
