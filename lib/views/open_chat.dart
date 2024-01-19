
import '../entities/user_data.dart';
import 'package:flutter/material.dart';


class OpenChatView extends StatefulWidget {
  final UserData userData;
  const OpenChatView({Key? key, required this.userData}) : super(key: key);

  @override
  _OpenChatViewState createState() => _OpenChatViewState();
}

class _OpenChatViewState extends State<OpenChatView> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Display the name of the user
      appBar: AppBar(
        title: Text(widget.userData.name),
      ),
    );
  }

}