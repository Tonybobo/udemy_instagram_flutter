import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post(
      {required this.datePublished,
      required this.description,
      required this.username,
      required this.likes,
      required this.postId,
      required this.postUrl,
      required this.profImage,
      required this.uid});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postUrl": postUrl,
        "profImage": profImage,
        "datePublished": datePublished,
        "postId": postId,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        datePublished: snapshot["datePublished"],
        description: snapshot["description"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        postUrl: snapshot["postUrl"],
        uid: snapshot["uid"],
        username: snapshot["username"],
        profImage: snapshot["profImage"]);
  }
}
