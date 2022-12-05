import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_flutter/Providers/theme_providers.dart';
import 'package:firebase_flutter/UI/Firestore/create_firestore.dart';
import 'package:firebase_flutter/UI/auth/login_screen.dart';
import 'package:firebase_flutter/UI/auth/post/add_post_screen.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadFirestorePost extends StatefulWidget {
  const ReadFirestorePost({super.key});

  @override
  State<ReadFirestorePost> createState() => _ReadFirestorePostState();
}

class _ReadFirestorePostState extends State<ReadFirestorePost> {
  // Firebase Auth:
  final auth = FirebaseAuth.instance;

  // Firebase Firestore Database Snapshot Reference to Read Data:
  final firestoreRef =
      FirebaseFirestore.instance.collection('users').snapshots();

  // For Update and Delete, We neeed Collection Reference:
  final collectionRef = FirebaseFirestore.instance.collection('users');

  // Text Editing Controller for Search bar:
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Provider for theme:

    final themeChanger = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Post Screen'),
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

          RadioListTile<ThemeMode>(
            title: Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: themeChanger.themeMode,
            onChanged: themeChanger.setTheme,
          ),

          RadioListTile<ThemeMode>(
            title: Text('Dark Theme'),
            value: ThemeMode.dark,
            groupValue: themeChanger.themeMode,
            onChanged: themeChanger.setTheme,
          ),

          // final themeChanger =  Provider.of(context);
          SizedBox(height: 12),

          // Read data using FirebaseAnimatedList:
          // Expanded is must for this realtime database:

          StreamBuilder<QuerySnapshot>(
            stream: firestoreRef,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();

              if (snapshot.hasError) return Text('Some Error Occoured');

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(snapshot.data!.docs[index]['title'].toString()),
                    subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              // Firestore Update:

                              String oldTitle = (snapshot
                                  .data!.docs[index]['title']
                                  .toString());

                              showDialog(
                                context: context,
                                builder: (context) {
                                  // To make Old title available on Field by default:

                                  editController.text = oldTitle;

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
                                            collectionRef
                                                .doc(snapshot
                                                    .data!.docs[index]['id']
                                                    .toString())
                                                .update({
                                              'id': snapshot
                                                  .data!.docs[index]['id']
                                                  .toString(),
                                              'title': editController.text
                                                  .toString(),
                                            }).then((value) {
                                              Navigator.pop(context);

                                              Utils()
                                                  .toastMessage('Post Updated');
                                            }).onError((error, stackTrace) {
                                              Utils().toastMessage(
                                                  error.toString());
                                            });
                                          },
                                          child: Text('Update')),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateFirestorePost(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
