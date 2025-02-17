import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/comments_screen.dart';
import 'package:instagram_flutter/Screens/profile_screen.dart';
import 'package:instagram_flutter/model/user.dart' as model;
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/gloabal_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLength=0;
  bool isLikeAnimating=false;
  @override
  void initState() {
    super.initState();
    getComments();
  }
  void getComments() async{
    try{
      QuerySnapshot snap=await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      commentLength=snap.docs.length;
    }catch( e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final model.User user = Provider.of<UserProvider>(context).getUser()!;
    //debugPrint("Hi..");
    return Container(
      decoration: BoxDecoration(
        color: width>webScreenSize? webBackgroundColor:mobileBackgroundColor,
        border: Border.all(color: width>webScreenSize? secondaryColor:mobileBackgroundColor)
      ),
      
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        //Header Section
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                .copyWith(right: 0),
            child: Row(
              children: [
                InkWell(
                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: widget.snap['uid']))),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap["profImage"]),
                  ),
                ),
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map((e) => InkWell(
                                          onTap: () async{
                                            await FirestoreMethods().deletePost(widget.snap['postId']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: ()async{
              await FirestoreMethods().like(
                'posts',
                widget.snap['postId'],
                user.uid,
                widget.snap['likes']
              );
              setState(() {
                isLikeAnimating=true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  )
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating? 1:0,
                  child: LikeAnimation( 
                    isAnimating: isLikeAnimating, 
                    duration: const Duration(milliseconds:400), 
                    onEnd: (){
                      setState(() {
                        isLikeAnimating=false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite, 
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),

          //Likes comment section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: ()async {
                    await FirestoreMethods().like(
                      'posts',
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes']
                    );
                  },
                  icon:  widget.snap['likes'].contains(user.uid) ? 
                  const Icon(
                    Icons.favorite_outlined,
                    color: Colors.red,
                  ) :
                  const Icon(
                    Icons.favorite_border
                  )
                ),
              ),
              //comment screen
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        id: widget.snap['postId'].toString(),
                        childName: 'posts',
                      ),
                    )
                  );
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                ),
              ))
            ],
          ),

          //Description and number of comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 0),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                        TextSpan(
                            text: widget.snap['username'] + "  ",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: widget.snap['description'],
                        ),
                      ])),
                ),
                InkWell(
                  onTap: () {

                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLength comments...',
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
