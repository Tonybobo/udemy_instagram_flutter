import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/users.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FirestoreMethods().postComment(
          widget.postId, commentEditingController.text, uid, name, profilePic);
      if (res != 'success') {
        if (context.mounted) showSnackBar(res, context);
      }
      setState(() {
        commentEditingController.text = '';
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Comments'),
          centerTitle: false),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  CommentCard(snap: snapshot.data!.docs[index]));
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 18,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                      controller: commentEditingController,
                      decoration: InputDecoration(
                          hintText: 'Comment as ${user.username}',
                          border: InputBorder.none)),
                )),
                InkWell(
                    onTap: () =>
                        postComment(user.uid, user.username, user.photoUrl),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: const Text('Post',
                            style: TextStyle(color: Colors.blue))))
              ]))),
    );
  }
}
