import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  final String id;

  final void Function(
    File image,
  )? messageImage;

  NewMessage(this.id, {this.messageImage});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var _enteredMessage = '';
  var _isInit = true;
  double _inputSize = 60;

  File? _messageImageFile;

  void _messageImage(File image) {
    _messageImageFile = image;
  }

  void _sendMessage() async {
    //FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userID': user.uid,
      'senderID': user.uid,
      'receiverID': widget.id.toString(),
      'userName': userData['username'],
      'message_image': userData['user_image'],
    });
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 140.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mensagem',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value.toString();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50),
                color: Colors.orangeAccent),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed:
                  _enteredMessage.toString().isEmpty ? () {} : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
