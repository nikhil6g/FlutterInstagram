import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/widgets/reels_item.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
            .collection('reels')
            .orderBy('datePublished',descending: true)
            .snapshots(), 
          builder: (context,snapshot){
            return PageView.builder(
              scrollDirection: Axis.vertical,
              controller: PageController(initialPage: 0,viewportFraction: 1),
              itemBuilder: (context,index){
                if(!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }
                return ReelsItem(snapshot.data!.docs[index].data());
              },
              itemCount: snapshot.data == null? 0: snapshot.data!.docs.length,
            );

          }
        )
      ),
    );
  }
}