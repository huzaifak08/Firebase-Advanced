import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/UI/Firestore/read_firestore.dart';
import 'package:firebase_flutter/UI/auth/login_screen.dart';
import 'package:firebase_flutter/UI/auth/post/post_screen.dart';
import 'package:firebase_flutter/UI/upload_image.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    // If user is already login then go to Post Screen after 3 Second Directly:

    if (user != null) {
      // Splash Screen Duration Code:
      Timer(
        Duration(seconds: 3),
        () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => UploadImageScreen()));
        },
      );

      // If user is already login then go to Login Screen after 3 Second Directly:
    } else {
      Timer(
        Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      );
    }
  }
}
