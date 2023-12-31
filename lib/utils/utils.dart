import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static bool checkEmail(String email) {
    if (email.isNotEmpty && RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return true;
    }
    return false;
  }

  static bool checkPassword(String password) {
    if (password.isNotEmpty && password.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(password)) {
      return true;
    }
    return false;
  }

  static Future<XFile?> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final Completer<XFile?> pickedImageCompleter = Completer();

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage = await picker.pickImage(source: ImageSource.camera);
                  pickedImageCompleter.complete(pickedImage);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                  pickedImageCompleter.complete(pickedImage);
                },
              ),
            ],
          ),
        );
      },
    );

    return pickedImageCompleter.future;
  }

}
