import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tab_manager.dart';
import 'register.dart';
import 'create_profile.dart';
import 'package:meet_mate/components/buttons.dart';
import 'package:meet_mate/components/text_fields.dart';
import 'package:meet_mate/utils/utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var formKey = GlobalKey<FormState>();
  var emailField = TextEditingController();
  var passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe87e70),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xffe87e70),
        foregroundColor: Colors.white,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              MainTextField(
                controller: emailField,
                labelText: 'Email',
                validator: (value) {
                  if (!Utils.checkEmail(emailField.text)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              MainTextField(
                controller: passwordField,
                labelText: 'Password',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16),
              MainButton(
                onPressed: () {
                  loginButtonClicked();
                },
                text: 'Login',
              ),
              const SizedBox(height: 16),
              NoBackgroundButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterView()),
                  );
                },
                text: 'Don\'t have an account? Register here',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginButtonClicked() async {
    if (formKey.currentState!.validate()) {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailField.text,
          password: passwordField.text
      ).then((value) {
        FirebaseFirestore.instance.collection('users').doc(value.user!.uid).get().then((value) {
          if (value.exists) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TabManager(uid: value.id)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateProfileView(uid: value.id)),
            );
          }
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email or password is incorrect")),
        );
      });
    }
  }
}