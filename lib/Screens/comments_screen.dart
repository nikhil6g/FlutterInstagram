import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/user.dart' as model;
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key,required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController=TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').orderBy('datePublished',descending: true).snapshots(), 
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,index)=>CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
          );
        }
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 8),
                  child: TextField(
                    decoration:const InputDecoration(
                      hintText: 'Comment as username',
                      border: InputBorder.none
                    ),
                    controller: _commentController,
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                  await FirestoreMethods().postComment(
                    widget.postId, 
                    _commentController.text, 
                    user.uid, 
                    user.username, 
                    user.photoUrl,
                  );
                  setState(() {
                    _commentController.text="";
                  });
                },
                child: Container(
                  padding:const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}