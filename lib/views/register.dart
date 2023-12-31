import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_profile.dart';
import 'login.dart';
import 'package:meet_mate/components/buttons.dart';
import 'package:meet_mate/components/text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  var formKey = GlobalKey<FormState>();
  var emailField = TextEditingController();
  var passwordField = TextEditingController();
  var repeatPasswordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe87e70),
      appBar: AppBar(
        backgroundColor: const Color(0xffe87e70),
        foregroundColor: Colors.white,
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              MainTextField(
                  controller: emailField,
                  labelText: 'Email',
                  validator: (value) {
                    if (!checkEmail(emailField.text)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }
              ),

              const SizedBox(height: 16),
              MainTextField(
                  controller: passwordField,
                  labelText: 'Password',
                  validator: (value) {
                    if (!checkPassword(passwordField.text)) {
                      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter and one number';
                    }
                    return null;
                  },
                  obscureText: true,
              ),

              const SizedBox(height: 16),
              MainTextField(
                  controller: repeatPasswordField,
                  labelText: 'Repeat Password',
                  validator: (value) {
                    if (repeatPasswordField.text != passwordField.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: true,
              ),

              const SizedBox(height: 16),
              MainButton(
                  onPressed: registerButtonClicked,
                  text: 'Register',
              ),
              NoBackgroundButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  },
                  text: 'Already have an account? Login here',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }


  void registerButtonClicked () async {
    if (formKey.currentState!.validate()) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailField.text,
          password: passwordField.text
      ).then((value) {
        // Store the image in firebase storage
        //FirebaseStorage.instance.ref('profile_images/${value.user!.uid}').putFile(profileImage!);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateProfileView(uid: value.user!.uid)),
        );

      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("That email already exists"))
        );
      });
    }
  }

  bool checkEmail(String email) {
    if (email.isNotEmpty && RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return true;
    }
    return false;
  }

  bool checkPassword(String password) {
    if (password.isNotEmpty && password.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(password)) {
      return true;
    }
    return false;
  }
}

