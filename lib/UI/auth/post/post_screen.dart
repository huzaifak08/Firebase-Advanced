import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_flutter/UI/auth/login_screen.dart';
import 'package:firebase_flutter/UI/auth/post/add_post_screen.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  // Firebase Auth:
  final auth = FirebaseAuth.instance;

  // Firebase RealTime Database:
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  // Text Editing Controller for Search bar:
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Screen'),
        centerTitle: true,

        // For removing back icon on app bar:
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                // Signing Out:

                auth.signOut().then((value) {
                  Utils().toastMessage('Sign Out');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout_outlined)),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilterController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),

              // For Search Filter:
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          // Read data using FirebaseAnimatedList:
          // Expanded is must for this realtime database:
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseRef,
              defaultChild: Center(child: CircularProgressIndicator()),
              itemBuilder: (context, snapshot, animation, index) {
                // For Search Filter;

                final title = snapshot.child('title').value.toString();

                if (searchFilterController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            title: Text('Edit'),
                            leading: Icon(Icons.edit),
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(
                                  title, snapshot.child('id').value.toString());
                            },
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            title: Text('Delete'),
                            leading: Icon(Icons.delete),
                            onTap: () {
                              Navigator.pop(context);
                              // Firebase Delete:
                              databaseRef
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilterController.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String oldTitle, String id) async {
    editController.text = oldTitle;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: TextField(
              controller: editController,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Firebase Update:
                  databaseRef.child(id).update({
                    'title': editController.text.toString(),
                  }).then((value) {
                    Utils().toastMessage('Post Updated Successfully');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: Text('Update')),
          ],
        );
      },
    );
  }
}
