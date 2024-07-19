
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  const CustomTextField(
    {
      super.key,
      required this.hintText,
      this.isPass=false,
      required this.textInputType,
      required this.textEditingController
    }
  );

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      controller: textEditingController,
      style:const TextStyle(fontSize: 20),
      decoration:InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(0),
      ),
      keyboardType:textInputType,
      obscureText: isPass,
    );
  }
}