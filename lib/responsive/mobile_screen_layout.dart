import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/add_post_screen.dart';
import 'package:instagram_flutter/Screens/upload_screen/upload_screen.dart';
import 'package:instagram_flutter/Screens/feed_screen.dart';
import 'package:instagram_flutter/Screens/profile_screen.dart';
import 'package:instagram_flutter/Screens/search_screen.dart';
//import 'package:instagram_flutter/Screens/add_post_screen.dart';
import 'package:instagram_flutter/model/user.dart'as model;
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';
class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page=0;
  late PageController pageController;
  
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    //print('call from mobilescreenlayout');
  }
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  void navigationTapped(int page){
    pageController.jumpToPage(page);
    
    setState(() {
    });
  }
  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser();
    List<Widget> homeScreenItem=[
      const FeedScreen(),
      const SearchScreen(),
      const UploadScreen(),
      const Text("reel"),
      ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
    ];
    //print('Welcome to mobile screen');
    return user==null ?const Center(child: CircularProgressIndicator()):
    Scaffold(
      body: PageView(
        
        physics: const NeverScrollableScrollPhysics(), //can't swipe pages
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItem,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor:const Color.fromARGB(255, 28, 28, 28),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: _page==0? primaryColor:secondaryColor),
            label: "home",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: _page==1? primaryColor:secondaryColor),
            label: "search",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle,color: _page==2? primaryColor:secondaryColor),
            label: "upload",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_file,color: _page==3? primaryColor:secondaryColor),
            label: "reel",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: _page==4? primaryColor:secondaryColor),
            label: "dp",
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
      )
    );
  }
}