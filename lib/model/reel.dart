class Reel{
  final String description;
  final String uid;
  final String username;
  final String reelId;
  final datePublished;
  final String reelUrl;
  final String profImage;
  final likes;
  const Reel(
    {
      required this.description,
      required this.uid,
      required this.username,
      required this.reelId,
      required this.datePublished,
      required this.profImage,
      required this.likes,
      required this.reelUrl,
    }
  );
  Map<String,dynamic> toJson()=>{
    'description':description,
    'uid':uid,
    'username': username,
    'reelId':reelId,
    'datePublished':datePublished,
    'profImage': profImage,
    'likes':likes,
    'reelUrl':reelUrl,
  };

}