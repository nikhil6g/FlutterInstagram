import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/model/user.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController=TextEditingController();
  bool _isLoading=false;

  void postImage(String uid,String username,String profImage)async{
    setState(() {
      _isLoading=true;
    });
    try{
      String res=await FirestoreMethods().uploadPost(
        _descriptionController.text, 
        _file!, 
        uid, 
        username, 
        profImage
      );
      if(res=="success"){
        showSnackBar('Posted', context);
        clearImage();
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
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            //for showing camera option
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: ()async {
                Navigator.of(context).pop();
                var file =await pickImage(ImageSource.camera);
                setState(() {
                  if(file!=null){
                  _file=file as Uint8List;
                  }
                });
              },
            ),

            //for showing gallery option
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose from gallary"),
              onPressed: ()async {
                Navigator.of(context).pop();
                final file =await pickImage(ImageSource.gallery);
                setState(() {
                  if(file!=null){
                    _file=file as Uint8List;
                  }
                });
              },
            ),
            //for cancel upload option
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
  void clearImage(){
    setState(() {
      _file=null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User user= Provider.of<UserProvider>(context).getUser()!;
    return _file==null?
    Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: ()=>_selectImage(context),
      )
    )
    :
    Scaffold(

      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: ()=>clearImage(),
        ),
        title:const Text("Post to"),
        actions : [
          TextButton(
            onPressed: ()=>postImage(user.uid,user.username,user.photoUrl),
            child: const Text(
              "post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            )
          )
        ]
      ),
      body: SingleChildScrollView(
        physics:const ClampingScrollPhysics(),
        child: Column(
          children: [
            _isLoading ? 
            const LinearProgressIndicator() 
            :
            const Padding(padding: EdgeInsets.only(top:0)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextField(
                    controller: _descriptionController,
                    decoration:const InputDecoration(
                      hintText: "write a caption..",
                      hintStyle: TextStyle(fontSize: 18),
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  )
                ),
                SizedBox(
                  height: 45,
                  width: 45,
                  child: AspectRatio(
                    aspectRatio: 487/451,
                    child:Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        )
        
                      ),
                    )
                  )
                ),
                const Divider(),
              ],
            ),
            /*Container(
              height: 200,
              width: 300,
              child:Center(
                child:Text("Hello"),
              )
            )*/
          ]
        ),
      ),
    );
  }
}