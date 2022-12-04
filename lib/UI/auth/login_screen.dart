import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/UI/auth/login_with_phone.dart';
import 'package:firebase_flutter/UI/auth/post/post_screen.dart';
import 'package:firebase_flutter/UI/auth/signup_screen.dart';
import 'package:firebase_flutter/UI/forgot_password.dart';
import 'package:firebase_flutter/utils/utils.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key to handle any empty Text Fields:
  final _formKey = GlobalKey<FormState>();

  // Controllers:
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Firebase Auhentication:
  final _auth = FirebaseAuth.instance;

  // Loading:
  bool loading = false;

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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
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
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Login Method of Firebase:
                    login();
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()));
                    },
                    child: Text('Forgot Password ?')),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ));
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginWithPhone()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Center(
                    child: Text('Login with Phone Number'),
                  ),
                ),
              ),
              SizedBox(height: 30),

              RoundButton(
                title: 'Sign in with Google',
                icon: FontAwesomeIcons.google,
                loading: loading,
                onTap: () {
                  logInWithGoogle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    // Before Sign In complete do Loading:
    setState(() {
      loading = true;
    });

    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())

        // When sign in then do this:
        .then(
      (value) {
        // Show loged in email at the toast message:
        Utils().toastMessage(value.user!.email.toString());

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostScreen(),
            ));

        // When Sign in Completes then stop Loading:
        setState(() {
          loading = false;
        });
      },
    )
        // In case of Errors do this:
        .onError(
      (error, stackTrace) {
        Utils().toastMessage(error.toString());

        // When error shows also stop the loading:
        setState(() {
          loading = false;
        });
      },
    );
  }

  void logInWithGoogle() async {
    setState(() {
      loading = true;
    });

    final googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        setState(() {
          loading = false;
        });
        return null;
      } else {
        final googleSignInAuth = await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuth.accessToken,
            idToken: googleSignInAuth.idToken);

        await FirebaseAuth.instance.signInWithCredential(credential);

        await FirebaseFirestore.instance.collection('gusers').add({
          'email': googleSignInAccount.email,
          'imageUrl': googleSignInAccount.photoUrl,
          'name': googleSignInAccount.displayName,
        });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PostScreen()));
      }
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }
}
