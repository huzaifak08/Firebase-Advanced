import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/UI/auth/post/post_screen.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class VerifyPhoneNumber extends StatefulWidget {
  final String verificationId;
  const VerifyPhoneNumber({
    super.key,
    required this.verificationId,
  });

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(hintText: '6 digit code'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 50),
            RoundButton(
              title: 'Verify Code',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                // Verifying Phone Code through Credential/Token:

                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: phoneController.text.toString(),
                );
                try {
                  await auth.signInWithCredential(credential);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
