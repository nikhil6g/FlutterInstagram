import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/user.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UploadReelScreen extends StatefulWidget {
  final File _videoFile;
  const UploadReelScreen(this._videoFile,{super.key});

  @override
  State<UploadReelScreen> createState() => _UploadReelScreenState();
}

class _UploadReelScreenState extends State<UploadReelScreen> {
  late VideoPlayerController controller;
  final captionController=TextEditingController();
  bool _isLoading=false;
  Uint8List? file;
  
  void uploadReel(String uid,String username,String profImage)async{
    setState(() {
      _isLoading=true;
    });
    try{
      String res=await FirestoreMethods().uploadReel(
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
  void dispose() {
    super.dispose();
    captionController.dispose();
  }
  @override
  void initState() {
    super.initState();
    //print("initState");
    file=widget._videoFile.readAsBytesSync();
    controller=VideoPlayerController.file(widget._videoFile)
      ..initialize().then((_){
        setState(() {
          
        });
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();
      }
    );
    //print("initState completed");
  }
  @override
  Widget build(BuildContext context) {
    //print("${controller.value.isInitialized}");
    final User user = Provider.of<UserProvider>(context).getUser()!;
    return Scaffold(
      appBar: AppBar(
        title:const Text('New Reels'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _isLoading ? 
              const LinearProgressIndicator() 
              :
              const Padding(padding: EdgeInsets.only(top:0)),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Container(
                  width: 270,
                  height: 300,
                  child: controller.value.isInitialized ?
                   AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                   )
                   :
                   const Center(child: CircularProgressIndicator()),
                  
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 60,
                width: 200,
                child: TextField(
                  maxLines: 10,
                  controller: captionController,
                  decoration:const InputDecoration(
                    hintText: 'write a caption...',
                    border: InputBorder.none
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child:const Text(
                      'Save Draft',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      uploadReel(user.uid, user.username, user.photoUrl);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child:const Text(
                        'Share',
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}