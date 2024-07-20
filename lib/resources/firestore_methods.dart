import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_flutter/model/post.dart';
import 'package:instagram_flutter/model/reel.dart';
import 'package:instagram_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  //upload post

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async{
    String res="Some error occured";
    try{
      String postId= const Uuid().v1();
      String photoUrl=await StorageMethods().uploadImage('posts', file, true);
      Post post=Post(
        description: description,
        uid: uid, 
        username: username, 
        postId: postId, 
        datePublished: DateTime.now(), 
        profImage: profImage, 
        likes: [], 
        postUrl: photoUrl
      );
      _firestore.collection('posts').doc(postId).set(post.toJson(),);
      res='success';
    }catch(err){
      res=err.toString();
    }
    return res;
  }

  Future<String> uploadReel(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async{
    String res="Some error occured";
    try{
      String reelId= const Uuid().v4();
      String reelUrl=await StorageMethods().uploadImage('reels', file, true);
      Reel reel=Reel(
        description: description,
        uid: uid, 
        username: username, 
        reelId: reelId, 
        datePublished: DateTime.now(), 
        profImage: profImage, 
        likes: [], 
        reelUrl: reelUrl
      );
      _firestore.collection('reels').doc(reelId).set(reel.toJson(),);
      res='success';
    }catch(err){
      res=err.toString();
    }
    return res;
  }


  Future<void> likePosts(String postId,String uid,List likes) async {
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayRemove([uid]),
        });
      }else{
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid]),
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

  //for commenting
  Future<void> postComment(String postId,String text,String uid,String name,String profilePic) async{
    try{
      if(text.isNotEmpty){
        String commentId= const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'name':name,
          'uid':uid,
          'text':text,
          'commentId':commentId,
          'datePublished': DateTime.now(),
          },SetOptions(merge: true));
      }else{
        print('text is empty');
      }
    }catch(e){
      print(e.toString());
    }
  }

  //for deleting post
  Future<void> deletePost(String postId) async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }

  //for following and U
  Future<void> updateFollower(String uid,String followId) async{
    try{
      var snap=await _firestore.collection('users').doc(uid).get();
      List following= (snap.data()! as dynamic)['following'];
      if(following.contains(followId)){
        print(following);
        await _firestore.collection('users').doc(followId).update({
          'followers':FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following':FieldValue.arrayRemove([followId])
        });
      }else{
        await _firestore.collection('users').doc(followId).update({
          'followers':FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following':FieldValue.arrayUnion([followId])
        });
      }
    }catch(e){
      print(e.toString());
    }
  }
}