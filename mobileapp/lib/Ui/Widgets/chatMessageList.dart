import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:studiesy/Ui/Widgets/message.dart';
import 'package:studiesy/models/databaseMethods.dart';

class ChatMessageList extends StatefulWidget {
  const ChatMessageList({
    super.key, this.chatroomId,
  });
  final chatroomId;
  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  Stream? chatMessageStream;

  @override
  void initState() {
    dataBaseMethods.getConversationMessage(widget.chatroomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => Message(
                        message: snapshot.data!.docs[index],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}
