import 'package:flutter/material.dart';
import 'package:instagram_flutter/main.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/utils/gloabal_variables.dart';
import 'package:provider/provider.dart';
class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({super.key,required this.webScreenLayout,required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
    void initState(){
      super.initState();
      //print('after refreshing user');
      addData();
      //print('Refreshing User');
    }
    addData() async{
      //debugPrint('Before dummy calls');
      UserProvider userProvider = Provider.of(context,listen: false);
      await userProvider.refreshUser();
      //print('after dummy calls');
    }
  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth>webScreenSize){
          //webScreen
          return widget.webScreenLayout;
        }else{
          //mobileScreen
          return widget.mobileScreenLayout;
        }
      }
    );
  }
}