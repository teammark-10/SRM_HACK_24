import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:studiesy/Ui/Widgets/text_message.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.message});

  final DocumentSnapshot message;

  @override
  Widget build(BuildContext context) {
    
    String url =
        'https://img.freepik.com/premium-photo/buddy-robot-with-computer-dextop_352934-3.jpg?w=900';
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: message.get('isSender')
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.get('isSender')) ...[
            CircleAvatar(
              radius: 4.w,
              backgroundImage: NetworkImage(url),
            )
          ],
          SizedBox(
            width: 2.w,
          ),
          TextMessage(message: message),
        ],
      ),
    );
  }
}