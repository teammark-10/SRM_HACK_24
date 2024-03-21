import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

import 'package:studiesy/Ui/audio.dart';
import 'package:studiesy/models/databaseMethods.dart';

import 'Widgets/chatMessageList.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen(
      {super.key,
      required this.chatRoomId,
      required this.userName,
      required this.subject});
  final String chatRoomId;
  final String userName;
  final String subject;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();

  DataBaseMethods dataBaseMethods = DataBaseMethods();

  Widget buildPastBuilder() {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        children: [Expanded(child: chatMessageList()), MessageBar()],
      ),
    );
  }

  Widget chatMessageList() {
    return Stack(children: [
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Center(
          child: Image.network(
            'https://img.freepik.com/free-vector/kids-studying-from-home-concept-illustration_114360-2153.jpg?w=740&t=st=1695441819~exp=1695442419~hmac=1c1f2c7698bfb93fad7a4f266aedc5cbee5f799f7d71b0c9ec1df5541c970b02',
            opacity: const AlwaysStoppedAnimation(.5),
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ChatMessageList(chatroomId: widget.subject),
        ],
      ),
    ]);
  }

  sendTextMessage(controller) {
    if (controller.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": controller.text,
        "isSender": true,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      dataBaseMethods.addConversationMessage(
          widget.subject, messageMap, controller.text, widget.subject);
      setState(() {
        controller.text = "";
      });
    }
  }

  Widget MessageBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 12, left: 12, right: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: Color(0xFF8070eb),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.3.h),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: messageController,
                onFieldSubmitted: (value) {
                  sendTextMessage(messageController);
                  print(messageController.text);
                },
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                )),
                decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                      color: Color.fromARGB(150, 254, 254, 254),
                      fontSize: 18,
                    )),
                    border: InputBorder.none),
              )),
              GestureDetector(
                onTap: () {
                  sendTextMessage(messageController);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: const Center(
                    child: Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 7, 7, 7),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String summarytext = '';

  @override
  void initState() {
    dataBaseMethods.fetchAudio(widget.subject);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFffffff),
        appBar: AppBar(
          backgroundColor: Color(0xFF8070eb),
          title: Text(
            "Eduverse",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
              color: Color.fromARGB(255, 248, 248, 248),
              fontSize: 22,
              fontWeight: FontWeight.w500,
            )),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AudioScreen(
                            subject: widget.subject,
                          )),
                );
              },
              icon: const Icon(Icons.speaker),
            ),
          ],
          shadowColor: const Color.fromARGB(255, 223, 147, 236),
          toolbarHeight: 70,
        ),
        body: buildPastBuilder());
  }
}
