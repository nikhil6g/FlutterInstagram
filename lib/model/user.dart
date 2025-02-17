import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  const User(
    {
      required this.email,
      required this.uid,
      required this.photoUrl,
      required this.username,
      required this.bio,
      required this.followers,
      required this.following
    }
  );
  Map<String,dynamic> toJson()=>{
    'username': username,
    'uid':uid,
    'email':email,
    'bio':bio,
    'followers':followers,
    'following':following,
    'photoUrl':photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap){
    // print(snap.toString());
    var snapshot = snap.data() as Map<String ,dynamic>;
    //print('for making user');
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
  /*static User dummyUser(){
    print('Welcome to User model');
    return const User(
      username: 'username',
      uid: 'uid',
      email: 'email',
      photoUrl: 'photoUrl',
      bio: 'bio',
      followers: [],
      following:[],
    );
  }*/
}