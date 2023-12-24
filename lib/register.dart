import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart';
import 'login.dart';

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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: emailField,
                validator: (value) {
                  if (!checkEmail(emailField.text)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                controller: passwordField,
                obscureText: true,
                validator: (value) {
                  if (!checkPassword(passwordField.text)) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Repeat Password'),
                controller: repeatPasswordField,
                obscureText: true,
                validator: (value) {
                  if (repeatPasswordField.text != passwordField.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: registerButtonClicked,
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                child: const Text('Already have an account? Login'),
              ),
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
          MaterialPageRoute(builder: (context) => const ChatView()),
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

