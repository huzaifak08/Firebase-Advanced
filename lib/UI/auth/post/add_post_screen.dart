import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;

  // A Table/Node of name Post is created in realtime database:
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  // Post Text Field Controller:
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              maxLength: 250,
              controller: postController,
              decoration: InputDecoration(
                hintText: 'Whats on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 18),
            RoundButton(
              loading: loading,
              title: 'Add Post',
              onTap: () {
                setState(() {
                  loading = true;
                });
                // Add Post using Realtime Firebase storage:

                // Here 1 is the id of child:
                // databaseRef.child('1').set({

                // Here the id of the child and the inner id will change according to time millisecond:

                String id = DateTime.now().microsecondsSinceEpoch.toString();
                databaseRef
                    // You can use child with in the child using-> toString().child()
                    .child(id)
                    .set({
                  'id': id,
                  'title': postController.text.toString(),
                }).then((value) {
                  // Loading is flase when complete:
                  setState(() {
                    loading = false;
                  });

                  Utils().toastMessage('Post Created Successfully');

                  Navigator.pop(context);
                }).onError((error, stackTrace) {
                  // Loading is flase when error occours:
                  setState(() {
                    loading = false;
                  });

                  Utils().toastMessage(error.toString());
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
