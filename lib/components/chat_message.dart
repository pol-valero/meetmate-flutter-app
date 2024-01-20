

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChatMessageLoggedUser extends StatelessWidget {

  final Message message;

  const ChatMessageLoggedUser({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(left: 200, top: 20, right: 20),
      child: Text(
        message.text!,
        style: TextStyle(
          color: Colors.white, // Text color
        ),
      ),
      decoration: BoxDecoration(
        color: const Color(0xffe87e70),
        borderRadius: BorderRadius.circular(15.0), // Set the border radius
      ),
    );
  }

}


class ChatMessageOtherUser extends StatelessWidget {

  final Message message;

  const ChatMessageOtherUser({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(left: 20, top: 20, right: 200),
      child: Text(
        message.text!,
        style: TextStyle(
          color: Colors.white, // Text color
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15.0), // Set the border radius
      ),
    );
  }

}