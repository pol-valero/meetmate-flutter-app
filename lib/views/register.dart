import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_profile.dart';
import 'login.dart';
import 'package:meet_mate/components/buttons.dart';
import 'package:meet_mate/components/text_fields.dart';
import 'package:meet_mate/utils/utils.dart';

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
        toolbarHeight: 100,
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
              MainTextField(
                  controller: emailField,
                  labelText: 'Email',
                  validator: (value) {
                    if (!Utils.checkEmail(emailField.text)) {
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
                    if (!Utils.checkPassword(passwordField.text)) {
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
}

