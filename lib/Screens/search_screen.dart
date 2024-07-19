import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/Screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/gloabal_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController=TextEditingController();
  bool isShowUsers= false;
  
  Future<QuerySnapshot<Map<String, dynamic>>> returnfuture1(){
    //print(1);
    return FirebaseFirestore.instance.collection('users')
        .where('username',isGreaterThanOrEqualTo: searchController.text)
        .get() ;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> returnfuture2(){
    //print(1);
    return FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title:TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (String _){
            setState(() {
              isShowUsers=true;
            });
          },
        ),
      ),
      body: //isShowUsers? 
      FutureBuilder(
        future:isShowUsers?  returnfuture1():returnfuture2(),
        builder: (context,snap){
          if(snap.connectionState==ConnectionState.waiting){
            
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          return isShowUsers? 
          ListView.builder(
            itemCount: snap.data!.docs.length,
            itemBuilder: (context,index){
              //print(snap.data!.docs[index]['description']);
              return InkWell(
                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: snap.data!.docs[index]['uid']))),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      (snap.data! as dynamic).docs[index]['photoUrl'],
                    ),
                    radius: 16,
                  ),
                  title: Text(snap.data!.docs[index]['username']),
                ),
              );
            }
          )
          :
          StaggeredGridView.countBuilder(
            crossAxisCount: 3,
            itemCount: (snap.data! as dynamic).docs.length, 
            itemBuilder: (context,index)=> Image.network(
              (snap.data! as dynamic).docs[index]['postUrl'],
              fit: BoxFit.cover,
            ),
            staggeredTileBuilder: (index) => width>webScreenSize? 
            StaggeredTile.count(
              (index%7==0)? 1:1, // crossAxisCellCount 
              (index%7==0)? 1:1//mainAxisCellCount
            )
            :
            StaggeredTile.count(
              (index%7==0)? 2:1, // crossAxisCellCount 
              (index%7==0)? 2:1//mainAxisCellCount
            ),
            
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          );
        }
      )
      //:
      /*FutureBuilder(
        future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
        builder: (context,snap){
          if(!snap.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StaggeredGridView.countBuilder(
            crossAxisCount: 3,
            itemCount: (snap.data! as dynamic).docs.length, 
            itemBuilder: (context,index)=> Image.network(
              (snap.data! as dynamic).docs[index]['postUrl'],
              fit: BoxFit.cover,
            ),
            staggeredTileBuilder: (index) => width>webScreenSize? 
            StaggeredTile.count(
              (index%7==0)? 1:1, // crossAxisCellCount 
              (index%7==0)? 1:1//mainAxisCellCount
            )
            :
            StaggeredTile.count(
              (index%7==0)? 2:1, // crossAxisCellCount 
              (index%7==0)? 2:1//mainAxisCellCount
            ),
            
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          );
        }
      )*/
      //Container(child:Text('posts'))
      //Center(child:Text('posts'))
    );
  }
}