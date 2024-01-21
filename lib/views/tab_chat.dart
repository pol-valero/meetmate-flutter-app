import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meet_mate/components/chat_list_container.dart';

import '../entities/user_data.dart';

class TabChatView extends StatefulWidget {
  const TabChatView({Key? key}) : super(key: key);

  @override
  _TabChatViewState createState() => _TabChatViewState();
}

class _TabChatViewState extends State<TabChatView> {

  late User loggedUser;
  late List<UserData> otherUsers = List.empty(growable: true);
  UserData loggedUserData = UserData();

  @override
  void initState() {
    super.initState();

    getUserMail().then((value) {
      getCurrentUserData().then((value) {
        getOtherUsers(loggedUser);
        setState(() {});
      });
    });

  }

  Future getCurrentUserData() async {
    await getUserDataFromUID(loggedUser.uid).then((value) {
      loggedUserData = value;
    });
  }

  //Function to get the mail of the current logged user
  Future getUserMail() async {
    loggedUser = FirebaseAuth.instance.currentUser!;
  }

  Future getOtherUsers(User loggedUser) async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    for (var user in users.docs) {
      if (user.id != loggedUser.uid) {

        await getUserDataFromUID(user.id).then((value) {
          otherUsers.add(value);
          setState(() { });
        });
      }
    }
  }

  Future<UserData> getUserDataFromUID(String uid) async {

    UserData userData = UserData();
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) async {
      userData.uid = uid;
      userData.name = value.get('name');
      var birthdate = value.get('birthdate');
      userData.age = (DateTime
          .now()
          .difference(DateTime.parse(birthdate))
          .inDays / 365).floor().toString();
      userData.interestsField = value.get('interests');
      userData.aboutMeField = value.get('about_me');

      await FirebaseStorage.instance.ref().child('profile_images/$uid').getDownloadURL().then((value) async {
        userData.profileImage = Image.network(value, height: 200, width: 200);
      });

      return userData;
    });

    return userData;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            itemCount: otherUsers.length,
            itemBuilder: (context, index) {
              return ChatListContainer(userData: otherUsers[index], loggedUserData: loggedUserData);
            }
        ),
      ),
    );
  }
}