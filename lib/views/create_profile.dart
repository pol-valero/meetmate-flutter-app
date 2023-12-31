import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'tab_manager.dart';

class CreateProfileView extends StatefulWidget {
  final String uid;
  const CreateProfileView({Key? key, required this.uid}) : super(key: key);

  // pass the uid to the state
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
  var colorPickImage = Colors.black;

  _CreateProfileViewState({required this.uid});

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
              if (profileImage != null)
                CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(profileImage!),
                )
              else
                Image.asset('assets/images/default_profile_image.png', height: 200, width: 200),

              const SizedBox(height: 12),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    pickImageClicked();
                  },
                  child: const Text('Pick Image'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorPickImage,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),

              if (colorPickImage == Colors.red)
                const Text('Please pick an image', style: TextStyle(color: Colors.red)),

              const SizedBox(height: 8),
              // Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: nameField,
                validator: (value) {
                  if (nameField.text.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Birth Date'),
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

              const SizedBox(height: 8),
              // Interests
              TextFormField(
                decoration: const InputDecoration(labelText: 'Interests'),
                controller: interestsField,
                validator: (value) {
                  if (interestsField.text.isEmpty) {
                    return 'Please enter valid interests';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // About Me
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'About Me'),
                controller: aboutMeField,
                validator: (value) {
                  if (aboutMeField.text.isEmpty) {
                    return 'Please enter valid information';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Finish Button
              Container(
                margin: const EdgeInsets.all(15),
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: createProfileClicked,
                  child: const Text('Create my profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickImageClicked() async {
    colorPickImage =  Colors.black;
    // ask if the user wants to take a picture or choose from gallery
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        }
    );

  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });
    }
  }

  void createProfileClicked () async {
    if (formKey.currentState!.validate() && profileImage != null) {
      // Save image
      FirebaseStorage.instance.ref('profile_images/$uid').putFile(profileImage!);

      // Save profile information
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameField.text,
        'birthdate': birthdateField.text,
        'interests': interestsField.text,
        'about_me': aboutMeField.text,
      });


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabManager(uid: uid)),
      );
    } else if (profileImage == null) {
      setState(() {
        colorPickImage = Colors.red;
      });
    }
  }
}


