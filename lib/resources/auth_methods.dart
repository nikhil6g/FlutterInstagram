import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/model/user.dart'as model;
import 'package:instagram_flutter/resources/storage_method.dart';
class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  static bool first=false;
  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;
    // print(currentUser.uid);
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    //print('succes for getting snap');
    return model.User.fromSnap(snap);
  }
  //sign up user
  Future<String> signUpUser({
    required String email,
    required String username,
    required String bio,
    required String password,
    required Uint8List file
  }) async{
    String res='Some error occured';
    try{
      if(email.isNotEmpty || username.isNotEmpty||password.isNotEmpty||bio.isNotEmpty){
        //register user
        UserCredential cred=await _auth.createUserWithEmailAndPassword(email: email, password: password);
        var uid=cred.user!.uid;
        //Add user in firestore database
        String photoUrl = await StorageMethods().uploadImage('profilePic', file, false);
        model.User user= model.User(email: email, uid: cred.user!.uid, photoUrl: photoUrl, username: username, bio: bio, followers: [], following: []);
        //print(user);
        first =true;
        await _firestore.collection("users").doc(uid).set(
          user.toJson()
        );
        res='success';
        print(res);
      }else{
        res='user needs to enter all the fields';
      }
    }catch(err){
      res=err.toString();
    }
    return res;
  }

  //logging user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res="Some error ocurred";
    try{
      if(email.isNotEmpty&&password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        
        res='success';
      }else{
        res='user needs to enter all the fields';
      }
    }on FirebaseAuthException catch(err){
      res=err.toString();
      print(res);
    }
    return res;
  }

  //sign out 
  Future<void> signOut() async{
    await _auth.signOut();
  }
}