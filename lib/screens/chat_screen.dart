import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Here all files
import '../widgets/messages.dart';
import '../widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  final String? imageUrl;

  ChatScreen({this.imageUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  var receivedArg = '';
  var userName = '';
  var userImage = '';

  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final pageId = ModalRoute.of(context)!.settings.arguments;
      if (pageId != null) {
        setState(() {
          receivedArg = pageId.toString();
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(receivedArg)
            .get()
            .then((value) {
          setState(() {
            userName = value.data()!['username'].toString();
            userImage = value.data()!['user_image'].toString();
          });
        });
        FirebaseFirestore.instance.collection('chat').get().then((value) {
          value.docs.forEach((result) {
            FirebaseFirestore.instance
                .collection('chat')
                .doc(result.id)
                .get()
                .then(
              (data) {
                if (data.data()!['receiverID'] == user!.uid &&
                    data.data()!['senderID'] == receivedArg) {
                  setState(() {
                    //for future
                  });
                }
              },
            );
          });
        });
      }
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/002.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigo,
          iconTheme: const IconThemeData(color: Colors.white, size: 30),
          titleSpacing: -5,
          shape: const Border(bottom: BorderSide(color: Colors.grey)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 20,
                    backgroundImage: NetworkImage(userImage.toString()),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Text(
                userName,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [Messages(receivedArg.toString())],
              ),
            ),
            NewMessage(receivedArg.toString()),
          ],
        ),
      ),
    );
  }
}
