
import 'package:meet_mate/views/tab_profile.dart';

import '../entities/user_data.dart';
import 'package:flutter/material.dart';


class OpenChatView extends StatefulWidget {
  final UserData userData;
  const OpenChatView({Key? key, required this.userData}) : super(key: key);

  @override
  _OpenChatViewState createState() => _OpenChatViewState(userData: userData);
}

class _OpenChatViewState extends State<OpenChatView> {

  final UserData userData;

  _OpenChatViewState({required this.userData});


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.userData.name),
        centerTitle: true,
      bottom: PreferredSize(
      preferredSize: Size.fromHeight(30.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TabProfileView(uid: userData.uid, editProfileMode: false),
            ),
          );
        },
        child: Text('View details'),
      ),
      ),
      ),
      body: Column(
        children: [

          const Expanded(
            child: Center(
              child: Text('Message Display Area'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [

                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    print('Send button clicked!');
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}