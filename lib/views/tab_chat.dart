import 'package:flutter/material.dart';

//TODO: Do the class properly is only for testing purposes
class TabChatView extends StatefulWidget {
  const TabChatView({Key? key}) : super(key: key);

  @override
  _TabChatViewState createState() => _TabChatViewState();
}

class _TabChatViewState extends State<TabChatView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('The CHAT are the friends we made along the way'),
      ),
    );
  }
}