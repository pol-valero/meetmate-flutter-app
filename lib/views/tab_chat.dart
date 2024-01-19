import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabChatView extends StatefulWidget {
  const TabChatView({Key? key}) : super(key: key);

  @override
  _TabChatViewState createState() => _TabChatViewState();
}

class _TabChatViewState extends State<TabChatView> {

  String userMail = '';

  @override
  void initState() {
    super.initState();

    getUserMail().then((value) {

        setState(() {});
    });

  }

  //Function to get the mail of the current logged user
  Future getUserMail() async {
    final user = FirebaseAuth.instance.currentUser;
    userMail = user!.email!;
    setState(() {
    });
  }

  //TODO: Function getOtherUsers() to get the list of other users


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(userMail),
      ),
    );
  }
}