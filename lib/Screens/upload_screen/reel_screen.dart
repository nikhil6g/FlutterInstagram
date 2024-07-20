import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/upload_screen/upload_reel_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:photo_manager/photo_manager.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final List<Widget> _mediaList=[];
  final List<File> path=[];
  File? _file;
  int currentPage=0;
  int? lastPage;

  _fetchNewMedia()async{
    lastPage=currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    //print(ps.isAuth);
    if(ps.isAuth){
      List<AssetPathEntity> album =await PhotoManager.getAssetPathList(type: RequestType.video);
      List<AssetEntity> media =await album[0].getAssetListPaged(page: currentPage, size: 60);
      for(var asset in media){
        if(asset.type== AssetType.video){
          //print(1);
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
                      ),
                      if(asset.type == AssetType.video)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width:35,
                            height: 15,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Text(
                                  asset.videoDuration.inMinutes.toString(),
                                  style:const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                  ),
                                ),
                                const Text(
                                  ':',
                                  style:TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  asset.videoDuration.inSeconds.toString(),
                                  style:const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                  ),
                                )
                              ],
                            ),
                          ),
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
    _fetchNewMedia();
    //print(_mediaList.length);
  }
  int chooseReelIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('New Reels'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: _mediaList.length,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 250,
            crossAxisSpacing: 3,
            mainAxisSpacing: 5
          ), 
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  chooseReelIndex=index;
                  _file = path[chooseReelIndex];
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>UploadReelScreen(_file!))
                  );
                });
              },
              child: _mediaList[index]
            );
          }
        )
      ),
    );
  }
}