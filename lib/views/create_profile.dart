import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_mate/components/buttons.dart';
import 'package:meet_mate/components/text_fields.dart';
import '../utils/utils.dart';
import 'tab_manager.dart';

class CreateProfileView extends StatefulWidget {
  final String uid;
  const CreateProfileView({Key? key, required this.uid}) : super(key: key);

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState(uid: uid);
}

class _CreateProfileViewState extends State<CreateProfileView> {
  final String uid;
  var formKey = GlobalKey<FormState>();
  var nameField = TextEditingController();
  var birthdateField = TextEditingController();
  var interestsField = TextEditingController();
  var aboutMeField = TextEditingController();
  File? profileImage;
  var isImagePicked = true;

  _CreateProfileViewState({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe87e70),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 64),
              if (profileImage != null)
                CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(profileImage!),
                )
              else
                Image.asset('assets/images/default_profile_image.png', height: 200, width: 200),

              const SizedBox(height: 16),
              ImageButton(
                onPressed: pickImageClicked,
              ),

              if (!isImagePicked)
                const Text('Please pick an image',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                ),

              const SizedBox(height: 16),

              MainTextField(
                controller: nameField,
                labelText: 'Name',
                validator: (value) {
                  if (nameField.text.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Birth Date',
                    filled: true,
                    fillColor: Colors.white,
                    enabled: true,
                    errorStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                ),
                controller: birthdateField,
                validator: (value) {
                  if (birthdateField.text.isEmpty) {
                    return 'Please enter a valid birth date';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());
                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  birthdateField.text = date.toString().substring(0, 10);
                },
              ),

              const SizedBox(height: 16),
              MainTextField(
                controller: interestsField,
                labelText: 'Interests',
                validator: (value) {
                  if (interestsField.text.isEmpty) {
                    return 'Please enter valid interests';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              MainTextField(
                controller: aboutMeField,
                labelText: 'About Me',
                validator: (value) {
                  if (aboutMeField.text.isEmpty) {
                    return 'Please enter something about yourself';
                  }
                  return null;
                },
                isMultiline: true,
              ),

              const SizedBox(height: 16),
              MainButton(
                onPressed: createProfileClicked,
                text: 'Create my profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickImageClicked() async {
    final pickedImage = await Utils.pickImage(context);
    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
        isImagePicked = true;
      });
    }
  }

  void createProfileClicked () async {
    if (formKey.currentState!.validate() && profileImage != null) {
      FirebaseStorage.instance.ref('profile_images/$uid').putFile(profileImage!);

      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameField.text,
        'birthdate': birthdateField.text,
        'interests': interestsField.text,
        'about_me': aboutMeField.text,
      }).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TabManager(uid: uid)),
        );
      });
    } else if (profileImage == null) {
      setState(() {
        isImagePicked = false;
      });
    }
  }
}


