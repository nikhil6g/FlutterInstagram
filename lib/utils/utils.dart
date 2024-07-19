import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
  final picker=ImagePicker();
  XFile? image= await picker.pickImage(source: source);
  if(image!=null){
    return image.readAsBytes();
  }
  debugPrint('No image Selected');
}

showSnackBar(String content,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
    )
  ));
}