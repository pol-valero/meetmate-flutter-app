
import 'package:meet_mate/components/chat_message.dart';
import 'package:meet_mate/views/tab_profile.dart';
import 'package:stream_chat/stream_chat.dart';

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

  var apiKey = "nxdbv8cgp2dk";

  final UserData userData;  //Data of the user we are writing to
  final UserData loggedUserData; //Data of the current logged user
  List<Message> messages = List.empty(growable: true);

  late final client;

  late final channel;

  final messageField = TextEditingController();


  _OpenChatViewState({required this.userData, required this.loggedUserData});

  @override
  void initState() {
    super.initState();
    initChat();
  }

  void initChat() async {

    client = StreamChatClient(
    apiKey, //API KEY
    logLevel: Level.INFO,
    );

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

    messages = state.messages;

    setState(() {
    });

  }

  void sendMessage() async {

    if (messageField.text.isNotEmpty) {

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

  void disconnectUser() async {
    await client.disconnectUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.userData.name),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            disconnectUser();
            Navigator.of(context).pop(); // This line will pop the current route off the stack
          },
        ),
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

           Expanded(
            child: Center(

              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  if (messages[index].user?.id == loggedUserData.uid) {
                    return ChatMessageLoggedUser(message: messages[index]);
                  } else {
                    return ChatMessageOtherUser(message: messages[index]);
                  }
                },
              ),
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