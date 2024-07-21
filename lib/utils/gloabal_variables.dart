import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/add_post_screen.dart';
import 'package:instagram_flutter/Screens/explore_screen.dart';
import 'package:instagram_flutter/Screens/upload_screen/upload_screen.dart';
import 'package:instagram_flutter/Screens/upload_screen/post_screen.dart';
import 'package:instagram_flutter/Screens/upload_screen/reel_screen.dart';

import 'package:instagram_flutter/Screens/feed_screen.dart';
import 'package:instagram_flutter/Screens/profile_screen.dart';
import 'package:instagram_flutter/Screens/search_screen.dart';

const webScreenSize=600;
List<Widget> uploadScreenItems =[
  const PostScreen(),
  const ReelScreen(),
];
List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const UploadScreen(),
  const ExploreScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];