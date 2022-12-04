import 'package:firebase_flutter/Firebase%20Services/splash_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Splash Service Class object:

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();

    // Splash Service using here:
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Firebase Tutorial'),
      ),
    );
  }
}
