import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  // Loading:
  bool loading = false;

  // File Pickers:
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Files')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pickedFile != null)
            Container(
              color: Colors.blue[100],
              child: Image.file(
                File(pickedFile!.path!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              height: 400,
            ),
          RoundButton(
            title: 'Select File',
            onTap: selectFile,
          ),
          SizedBox(height: 30),
          RoundButton(
            title: 'Upload File',
            loading: loading,
            onTap: () async {
              setState(() {
                loading = true;
              });
              final path = 'files/${pickedFile!.name}';
              final file = File(pickedFile!.path!);

              final ref = FirebaseStorage.instance.ref().child(path);

              setState(() {
                uploadTask = ref.putFile(file);
              });

              final snapshot = await uploadTask!.whenComplete(() {});

              final urlDownload = await snapshot.ref.getDownloadURL();
              print('Download Link $urlDownload');

              setState(() {
                uploadTask = null;
                loading = false;
              });
              Utils().toastMessage('File Uploaded');
            },
          ),
        ],
      )),
    );
  }
}
