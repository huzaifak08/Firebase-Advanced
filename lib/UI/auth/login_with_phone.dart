import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/UI/auth/verify_phone.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login With Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(hintText: '+1 2345 678'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 50),
            RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                // Firebase Phone Authentication:

                auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (error) {
                    Utils().toastMessage(error.toString());
                  },
                  codeSent: (String verificationId, int? token) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VerifyPhoneNumber(verificationId: verificationId),
                        ));
                  },
                  codeAutoRetrievalTimeout: (error) {
                    Utils().toastMessage(error);
                    setState(() {
                      loading = false;
                    });
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
