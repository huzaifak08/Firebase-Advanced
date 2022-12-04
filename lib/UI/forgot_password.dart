import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Enter Email'),
            ),
            SizedBox(height: 40),
            RoundButton(
              title: 'Reset Password',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  Utils().toastMessage(
                      'Verify email by entering the code we send');

                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());

                  setState(() {
                    loading = false;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
