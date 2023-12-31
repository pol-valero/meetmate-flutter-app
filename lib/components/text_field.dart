import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
    final TextEditingController controller;
    final String labelText;
    final String? Function(String?)? validator;
    final bool obscureText;

    const MainTextField({
        Key? key,
        required this.controller,
        required this.labelText,
        required this.validator,
        this.obscureText = false,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return TextFormField(
            decoration: InputDecoration(
                labelText: labelText,
                filled: true,
                fillColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                ),
            ),
            controller: controller,
            obscureText: obscureText,
            validator: validator,
        );
    }
}
