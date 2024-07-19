import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/gloabal_variables.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late PageController uploadController;
  int _currentIndex=0;
  @override
  void initState() {
    super.initState();
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