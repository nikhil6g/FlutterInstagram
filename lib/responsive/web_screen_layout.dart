import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/model/user.dart'as model;
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/gloabal_variables.dart';
import 'package:provider/provider.dart';
class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
      _page=page;
    });
  }
  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }
  @override
  Widget build(BuildContext context) {
    model.User? user= Provider.of<UserProvider>(context).getUser();
    return user==null ? const CircularProgressIndicator():
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: ()=>navigationTapped(0), 
            
            icon: Icon(
              Icons.home,
              color: _page == 0?primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed: ()=>navigationTapped(1), 
            
            icon:Icon(
              Icons.search,
              color: _page == 1?primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed: ()=>navigationTapped(2), 
            
            icon: Icon(
              Icons.add_a_photo,
              color: _page == 2?primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed: ()=>navigationTapped(3), 
            
            icon: Image.asset('assets/instagram-reels-icon.png',height: 20,color:_page==3?Colors.white: Colors.white54,),
          ),
          IconButton(
            onPressed: ()=>navigationTapped(4), 
            
            icon: Icon(
              Icons.person,
              color: _page == 4?primaryColor:secondaryColor,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      )
    );
  }
}