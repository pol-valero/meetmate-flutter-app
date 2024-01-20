
import 'package:meet_mate/views/tab_profile.dart';
import 'package:stream_chat/stream_chat.dart';

import '../components/text_fields.dart';
import '../entities/user_data.dart';
import 'package:flutter/material.dart';


class OpenChatView extends StatefulWidget {
  final UserData userData;
  final UserData loggedUserData;
  const OpenChatView({Key? key, required this.userData, required this.loggedUserData}) : super(key: key);

  @override
  _OpenChatViewState createState() => _OpenChatViewState(userData: userData, loggedUserData: loggedUserData);
}

class _OpenChatViewState extends State<OpenChatView> {

  final apiKey = "nxdbv8cgp2dk";
  final UserData userData;  //Data of the user we are writing to
  final UserData loggedUserData; //Data of the current logged user

  final client = StreamChatClient(
    "nxdbv8cgp2dk",
    logLevel: Level.INFO,
  );

  late final channel;

  final messageField = TextEditingController();


  _OpenChatViewState({required this.userData, required this.loggedUserData});

  @override
  void initState() {
    super.initState();
    initChat();
  }

  void initChat() async {

    final user = User(id: userData.uid, extraData: {
      'name': userData.name,
    });

    final loggedUser = User(id: loggedUserData.uid, extraData: {
      'name': loggedUserData.name,
    });

    //We do this to create the user if it didn't exist
    await client.connectUser(user, client.devToken(userData.uid).rawValue);
    await client.disconnectUser();


    await client.connectUser(loggedUser, client.devToken(loggedUserData.uid).rawValue);


    channel = client.channel("messaging", extraData: {"members": [userData.uid, loggedUserData.uid]});

    loadMessages();

  }

  void loadMessages() async {
    var state = await channel.watch();

    print("Mensajes canal: ");

    //for each message, we print it
    for (var message in state.messages) {
      print("Usuario: " + message.user.name);
      print("Texto: " + message.text);
      print("");
    }
  }

  void sendMessage() async {

    if (messageField.text.isNotEmpty) {

      var state = await channel.watch();

      final message = Message(text: messageField.text);

      await channel.sendMessage(message);

      setState(() {
        messageField.text = '';
      });

      loadMessages();

    } else {
      print("Empty message field");
    }

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
                  Expanded(
                  child: TextField(
                    controller: messageField,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    sendMessage();
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