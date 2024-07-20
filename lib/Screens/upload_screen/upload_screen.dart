
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/gloabal_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late PageController uploadController;
  int _currentIndex=0;
  
  /*Future<void> getPermission() async{
    var status = await Permission.photos.request();
    print(status);
    if(status==PermissionStatus.granted){
      debugPrint("permission granted");
    }else if(status==PermissionStatus.denied){
      debugPrint("permission denied");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:const Text('Cannot Access storage'),
          action: SnackBarAction(
            label: 'Open App Settings', 
            onPressed: (){
              openAppSettings();
            }
          ),
        )
      );
    }else if(status==PermissionStatus.limited){

    }else if(status==PermissionStatus.restricted){
      debugPrint("Permission restricted");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:const Text('Allow us to use storage'),
          action: SnackBarAction(
            label: 'Open App Settings', 
            onPressed: (){
              openAppSettings();
            }
          ),
        )
      );
    }else if(status==PermissionStatus.permanentlyDenied){
      debugPrint("Permission permanantly denied");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:const Text('Can\'t use storage'),
          action: SnackBarAction(
            label: 'Open App Settings', 
            onPressed: (){
              openAppSettings();
            }
          ),
        )
      );
    }
  }
 */
  @override
  void initState() {
    super.initState();
    //getPermission();
    uploadController=PageController();
  }
  @override
  void dispose() {
    super.dispose();
    uploadController.dispose();
  }
  onPageChanged(int page){
    setState(() {
      _currentIndex=page;
    });
  }
  navigationTapped(int page){
    uploadController.jumpToPage(page);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: uploadController,
              onPageChanged: onPageChanged,
              children: uploadScreenItems,
            ),
            AnimatedPositioned(
              duration:const Duration(milliseconds: 300),
              bottom: 16,
              right: _currentIndex == 0? 100:150,
              child: Container(
                width: 120,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap:() => navigationTapped(0),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _currentIndex == 0 ? primaryColor:secondaryColor,
                        ),
                      
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigationTapped(1),
                      child: Text(
                        'Reel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _currentIndex == 1 ? primaryColor:secondaryColor,
                        ),
                      ),
                    )
                  ]
                ),
              ),
            )
          ],
        )
      )
    );
  }
}