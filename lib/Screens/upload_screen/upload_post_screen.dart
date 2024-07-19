
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/user.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class UploadPostScreen extends StatefulWidget {
  final File _file;
  const UploadPostScreen(this._file,{super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  TextEditingController captionController= TextEditingController();
  TextEditingController locationController= TextEditingController();
  Uint8List? file;
  bool _isLoading=false;
  @override
  void initState() {
    super.initState();
    file=widget._file.readAsBytesSync();
  }
  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
    locationController.dispose();
  }
  void postImage(String uid,String username,String profImage)async{
    setState(() {
      _isLoading=true;
    });
    try{
      String res=await FirestoreMethods().uploadPost(
        captionController.text, 
        file!, 
        uid, 
        username, 
        profImage
      );
      if(res=="success"){
        showSnackBar('Posted', context);
        Navigator.of(context).pop();
      }else{
        showSnackBar(res, context);
      }
    }catch(err){
      showSnackBar(err.toString(), context);
    }
    setState(() {
      _isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser()!;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        title: const Text(
          'New Post',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: InkWell(
                onTap:(){
                  postImage(user.uid, user.username, user.photoUrl);
                },
                child:const Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            _isLoading ? 
            const LinearProgressIndicator() 
            :
            const Padding(padding: EdgeInsets.only(top:0)),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                        image: FileImage(
                          widget._file,
                        ),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  const SizedBox(width: 15,),
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: TextField(
                      controller: captionController,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption...',
                        border: InputBorder.none
                      ),
                    ),
                  )
                ],
              ),
            ),
            /*const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: SizedBox(
                width: 200,
                height: 30,
                child: TextField(
                  controller: locationController,
                    decoration: const InputDecoration(
                      hintText: 'Add location',
                      border: InputBorder.none
                    ),
                ),
              ),
            )*/
          ],
        
        )
      ),
    );
  }
}