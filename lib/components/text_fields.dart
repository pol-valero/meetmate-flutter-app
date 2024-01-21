import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
    final TextEditingController controller;
    final String labelText;
    final String? Function(String?)? validator;
    final bool obscureText;
    final bool enabled;
    final bool isMultiline;

    const MainTextField({
        Key? key,
        required this.controller,
        required this.labelText,
        required this.validator,
        this.enabled = true,
        this.obscureText = false,
        this.isMultiline = false,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return TextFormField(
            decoration: InputDecoration(
                labelText: labelText,
                filled: true,
                fillColor: Colors.white,
                enabled: enabled,
                errorMaxLines:3,
                errorStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                ),
            ),
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            maxLines: isMultiline ? null : 1,
            keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
        );
    }
}

class EditingTextField extends StatelessWidget {
    final TextEditingController controller;
    final String labelText;
    final bool enabled;
    final bool isMultiline;
    final String? Function(String?)? validator;

    const EditingTextField({
        Key? key,
        required this.controller,
        required this.labelText,
        this.enabled = true,
        this.isMultiline = false,
        this.validator,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return TextFormField(
            decoration: InputDecoration(
                labelText: labelText,
                filled: true,
                fillColor: Colors.white,
                enabled: enabled,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                ),
            ),
            controller: controller,
            validator: validator,
            maxLines: isMultiline ? null : 1,
            keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
        );
    }
}



