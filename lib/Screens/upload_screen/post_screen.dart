import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/upload_screen/upload_post_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:photo_manager/photo_manager.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<Widget> _mediaList=[];
  final List<File> path=[];
  File? _file;
  int currentPage=0;
  int? lastPage;
  
  _fetchNewMedia()async{
    lastPage=currentPage;
    
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    print(ps.isAuth);
    if(ps.isAuth){
      List<AssetPathEntity> album =await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> media =await album[0].getAssetListPaged(page: currentPage, size: 60);
      for(var asset in media){
        if(asset.type== AssetType.image){
          print(1);
          final file= await asset.file;
          if(file!=null){
            path.add(File(file.path));
            _file=path[0];
          }
        }
      }
      List<Widget> temp=[];
      for(var asset in media){
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)), 
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                //print(snapshot.data!);
                return Container(
                  child:Stack(
                    children: [
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        )
                      )
                    ],
                  )
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          )
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        //print(temp.length);
        currentPage++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //PhotoManager.clearFileCache();
    _fetchNewMedia();
    //print(_mediaList.length);
  }
  int choosePhotoIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        title: const Text('New Post'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: (){
                  if(_file == null){
                    showSnackBar('Please Select a photo', context);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>UploadPostScreen(_file!))
                  );
                },
                child:const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 375,
                child: GridView.builder(
                  itemCount: 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1
                  ), 
                  itemBuilder: (context,index){
                    //print("${_mediaList[choosePhotoIndex]} + $choosePhotoIndex");
                    return _mediaList.isEmpty? Container():_mediaList[choosePhotoIndex];
                  }
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                color: mobileBackgroundColor,
                child:const Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  ],
                )
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 2
                ), 
                itemBuilder: (context,index){
                  //print(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        choosePhotoIndex=index;
                        _file=path[choosePhotoIndex];
                      });
                    },
                    child: _mediaList[index]
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

