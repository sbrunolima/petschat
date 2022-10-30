import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBuble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isHim;
  final bool canRead;
  final bool canReceive;
  final Key? key;

  MessageBuble(
      this.message, this.isMe, this.isHim, this.canRead, this.canReceive,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe ? myMessageWidget(message) : const SizedBox(),
            isHim ? hisMessageWidget(message) : const SizedBox(),
          ],
        ),
      ],
      clipBehavior: Clip.none,
    );
  }

  Widget myMessageWidget(String message) {
    return canRead
        ? Container(
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(0),
              ),
            ),
            //width: 240,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget hisMessageWidget(String message) {
    return canReceive
        ? Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(12),
              ),
            ),
            //width: 240,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
