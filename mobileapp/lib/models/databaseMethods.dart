import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  getNotes() async {
    return db.collection('Notes').snapshots();
  }

  updateNotes(String subject, String transcribe) async {
    QuerySnapshot snapshotUserInfo;
    await db
        .collection('Notes')
        .where('name', isEqualTo: subject)
        .get()
        .then((value) => {
              snapshotUserInfo = value,
              db.collection('Notes').doc(subject).update({
                'transcribe':
                    snapshotUserInfo.docs[0]['transcribe'] + transcribe,
              }),
            });
    String url = 'https://studiesy-glass.onrender.com/summary';
    Future.delayed(const Duration(seconds: 30));
    final result = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "subject": subject,
      }),
    );
    if (result.statusCode == 200) {
      // If the server did return a 201 CREATED result,
      // then parse the JSON.
      print(jsonDecode(result.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album');
    }
  }

  getConversationMessage(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy("time", descending: true)
        .snapshots();
  }

  addConversationMessage(
      String chatRoomId, messageMap, question, subject) async {
    print(subject);
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
    Future.delayed(Duration(seconds: 2), () async {
// code to be executed after 2 seconds
      await callBackend(question, subject);
    });
  }

  callBackend(String question, subject) async {
    final response = await http.post(
      Uri.parse('https://studiesy.onrender.com/bot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "question": question,
        "subject": subject,
        "time": DateTime.now().millisecondsSinceEpoch
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> messagesuccess = {
        "message": jsonDecode(response.body)["result"],
        "isSender": false,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      // FirebaseFirestore.instance
      //     .collection('chatroom')
      //     .doc(chatRoomId)
      //     .collection('chats')
      //     .add(messagesuccess)
      //     .catchError((e) {
      //   print(e.toString());
      // });
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album');
    }
  }

  fetchAudio(subject) async {
    QuerySnapshot snapshotUserInfo;
    String summary = '';
    await db.collection('Notes').where('name', isEqualTo: subject).get().then(
        (value) => {
              snapshotUserInfo = value,
              summary = snapshotUserInfo.docs[0].get('summary')
            });
    final audioResult = await http.post(
      Uri.parse('https://flask-3odj.onrender.com/voice'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "sentence": summary,
        "subject": subject,
      }),
    );
    if (audioResult.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(
        jsonDecode(audioResult.body),
      );
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album');
    }
  }
}
