import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/login_screen.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key,required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String,dynamic> userData={};
  bool isLoading=false;
  int postlen=0;
  int followers=0;
  int following=0;
  bool isfollowing=false;
  @override
  void initState() {
    super.initState();
    getData();
  }
  
  getData() async{
    //print(1);
    setState(() {
      isLoading=true;
    });
    try{
      //get user data
      var userSnap=await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      userData = userSnap.data()!;
      var postSnap=await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get();
      postlen=postSnap.docs.length;
      followers=userData['followers'].length;
      following= userData['following'].length;
      isfollowing=userData['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isLoading=false;
      });
    }catch(e){
      showSnackBar(e.toString(), context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    const Center(
      child: CircularProgressIndicator(),
    ):
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStateColumn(postlen, 'posts'),
                              buildStateColumn(followers, 'followers'),
                              buildStateColumn(following, 'following'),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid==widget.uid?
                              Row(
                                children:[
                                  FollowButton(
                                    backgroundColor: mobileBackgroundColor, 
                                    borderColor: Colors.grey, 
                                    text: "Edit Profile", 
                                    textColor: primaryColor,
                                    function: (){},
                                    width: 108,
                                  ),
                                  FollowButton(
                                    backgroundColor: mobileBackgroundColor, 
                                    borderColor: Colors.grey, 
                                    text: "Sign out", 
                                    textColor: primaryColor,
                                    width:108,
                                    function: ()async{
                                      await AuthMethods().signOut();
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>const LoginScreen()));
                                    },
                                  ),
                                ]
                              )
                              : isfollowing?
                              FollowButton(
                                backgroundColor: Colors.white, 
                                borderColor: Colors.grey, 
                                text: 'Unfollow', 
                                textColor: Colors.black,
                                function: ()async{
                                  await FirestoreMethods().updateFollower(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                                  setState(() {
                                    isfollowing=false;
                                    followers--;
                                  });
                                }
                              )
                              : 
                              FollowButton(
                                backgroundColor: Colors.blue, 
                                borderColor: Colors.grey, 
                                text: 'Follow', 
                                textColor: Colors.white,
                                function: ()async{
                                  await FirestoreMethods().updateFollower(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                                  setState(() {
                                    isfollowing=true;
                                    followers++;
                                  });
                                }
                              ),
                            ],
                          )
                        ],

                      ),
                    ),
                    
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userData['username'],
                    style:const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userData['bio'],
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          FirebaseAuth.instance.currentUser!.uid==widget.uid||isfollowing?
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(), 
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }
              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data!as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ), 
                itemBuilder: (context,index){
                  DocumentSnapshot snap=(snapshot.data!as dynamic).docs[index];
                  return SizedBox(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                }
              );
            }
          )
          :
          const SizedBox(
            child: Text(
              'This account is private!!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          )
        ]
        

      ),
    );
  }

  Column buildStateColumn(int num,String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style:const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style:const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
