import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/comments_screen.dart';
import 'package:instagram_flutter/model/user.dart' as model;
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ReelsItem extends StatefulWidget {
  final snapshot;
  const ReelsItem(this.snapshot,{super.key});

  @override
  State<ReelsItem> createState() => _ReelsItemState();
}

class _ReelsItemState extends State<ReelsItem> {
  int commentLength=0;
  late VideoPlayerController controller;
  bool play=true;
  @override
  void initState() {
    super.initState();
    //ignore: deprecated_meber_use
    controller= VideoPlayerController.network(widget.snapshot['reelUrl'])
      ..initialize().then((value) => {
        setState(() {
          controller.setLooping(true);
          controller.setVolume(1);
          controller.play();
        })
      }
    );
    getComments();
  }
  void getComments() async{
    try{
      QuerySnapshot snap=await FirebaseFirestore.instance.collection('reels').doc(widget.snapshot['reelId']).collection('comments').get();
      commentLength=snap.docs.length;
    }catch( e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser()!;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              play=!play;
            });
            if(play){
              controller.play();
            }else{
              controller.pause();
            }
          },
          child: SizedBox(
            width: double.infinity,
            height: 812,
            child: VideoPlayer(controller),
          ),
        ),
        !play?
        const Center(
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 35,
            child: Icon(
              Icons.play_arrow,size: 35,
              color: Colors.white,
            ),
          ),
        )
        :
        Container(),
        Positioned(
          top: 340,
          right: 15,
          child: Column(
            children: [
              GestureDetector(
                onTap: ()async{
                  await FirestoreMethods().like(
                    'reels',
                    widget.snapshot['reelId'],
                    user.uid,
                    widget.snapshot['likes']
                  );
                  setState(() {
                    
                  });
                },
                child: widget.snapshot['likes'].contains(user.uid) ?
                const Icon(Icons.favorite_outlined,color: Colors.red,size: 20,)
                :
                const Icon(Icons.favorite_border,color: Colors.white,size: 20,),
              ),
              const SizedBox(height: 3,),
              Text('${widget.snapshot['likes'].length}',style:const TextStyle(fontSize: 12,color: Colors.white),),
              const SizedBox(height: 14,),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        id: widget.snapshot['reelId'], 
                        childName: 'reels'
                      )
                    )
                  );
                }, 
                child: const Icon(Icons.comment,color: Colors.white,size: 20,),
              ),
               
              const SizedBox(height: 3,),
              Text('$commentLength',style:const TextStyle(fontSize: 12,color: Colors.white),),
              const SizedBox(height: 14,),
              const Icon(Icons.send,color: Colors.white,size: 20,),
              const SizedBox(height: 3,),
              Text('0',style: TextStyle(fontSize: 12,color: Colors.white),),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          left: 10,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    backgroundImage: NetworkImage(widget.snapshot['profImage']),
                    
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.snapshot['username'],
                    style:const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),

                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if(!(user.followers.contains(widget.snapshot['uid'])))
                    Container(
                      width: 60,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue,
                      ),
                      child:const Text(
                        'Follow',
                        style:TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.snapshot['description'],
                style:const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}