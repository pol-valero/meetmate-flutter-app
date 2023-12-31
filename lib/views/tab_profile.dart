import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: Do the class properly is only for testing purposes
class TabProfileView extends StatefulWidget {
  final String uid;
  const TabProfileView({Key? key, required this.uid}) : super(key: key);

  @override
  _TabProfileViewState createState() => _TabProfileViewState(uid: uid);

}

class _TabProfileViewState extends State<TabProfileView> {
  final String uid;
  Image profileImage = Image.asset('assets/images/default_profile_image.png', height: 200, width: 200);
  String name = 'Name';
  String age = 'Age';
  var interestsField = TextEditingController();
  var aboutMeField = TextEditingController();
  String edit = 'Edit';
  bool editable = false;
  var formKey = GlobalKey<FormState>();


  _TabProfileViewState({required this.uid});

  @override
  void initState() {
    super.initState();
      getProfileInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 64),
              CircleAvatar(
                radius: 100,
                backgroundImage: profileImage.image,
              ),
              const SizedBox(height: 12),

              // put a centered text Name - Age
              Text(name + ' - ' + age, style:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Interests',
                  enabled: editable,
                ),
                controller: interestsField,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your interests';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'About Me',
                  enabled: editable,
                ),
                controller: aboutMeField,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter something about yourself';
                  }
                  return null;
                },
              ),
              const SizedBox(height:32),

              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (editable) {
                        saveProfileInfo();
                      } else {
                        editable = true;
                        edit = 'Save';
                      }
                    });
                  },
                  child: Text(edit),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  void saveProfileInfo() async {
    if (formKey.currentState!.validate()) {
      // we need to save the interests controller and about me controller
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'interests': interestsField.text,
        'about_me': aboutMeField.text,
      }).then((value) {
        setState(() {
          editable = false;
          edit = 'Edit';
        });
      });
    }
  }



  void getProfileInfo() async {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      setState(() {
        name = value.get('name');
        var birthdate = value.get('birthdate');
        age = (DateTime.now().difference(DateTime.parse(birthdate)).inDays / 365).floor().toString();
        interestsField.text = value.get('interests');
        aboutMeField.text = value.get('about_me');
      });
    });

    FirebaseStorage.instance.ref().child('profile_images/$uid').getDownloadURL().then((value) {
      setState(() {
        profileImage = Image.network(value, height: 200, width: 200);
      });
    });
  }
}