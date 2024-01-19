import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../entities/user_data.dart';

class TabChatView extends StatefulWidget {
  const TabChatView({Key? key}) : super(key: key);

  @override
  _TabChatViewState createState() => _TabChatViewState();
}

class _TabChatViewState extends State<TabChatView> {

  late User loggedUser;
  late List<UserData> otherUsers = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    getUserMail().then((value) {
        getOtherUsers(loggedUser);
        setState(() {});
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

        //We can get the user data
        //print(user.data()['name']);

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
              return InkWell(
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffe87e70),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              otherUsers[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xffe87e70),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: otherUsers[index].profileImage,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeInfoView(recipe: recipes[index]),
                    ),
                  );*/
                },
              );
            }
        ),
      ),
    );
  }
}