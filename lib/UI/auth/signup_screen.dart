import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/UI/auth/login_screen.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Key to handle any empty Text Fields:
  final _formKey = GlobalKey<FormState>();

  // Loading:
  bool loading = false;

  // Controllers:
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Firebase Authentication:
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUP Scrren'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use TextFields inside the Form to handle empty Text Fields:
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      label: Text('Enter Email'),
                      helperText: 'someone@gmail.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Email';
                      } else
                        null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text('Enter Password'),
                      prefixIcon: Icon(Icons.password_outlined),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Password';
                      } else
                        null;
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            RoundButton(
              title: 'Sign UP',
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  signUp();
                }
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Login In'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Firebase Method:

  void signUp() {
    // Loading true here;
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) {
      // In case of then no loading:
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      // Utils Class Object:
      // Utils utils = Utils();

      Utils().toastMessage(error.toString());

      // In Case of Error loading is:
      setState(() {
        loading = false;
      });
    });
  }
}
