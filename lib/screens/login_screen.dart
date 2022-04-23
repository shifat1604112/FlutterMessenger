import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_flutter/screens/widgets.dart';
import 'package:messenger_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_flutter/services/database.dart';
import 'package:messenger_flutter/helper/helperfunctions.dart';
import 'package:messenger_flutter/screens/chatrooms.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;

  LoginScreen(this.toggleView);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  //AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final newUser = await _auth.signInWithEmailAndPassword(
          email: emailEditingController.text,
          password: passwordEditingController.text);
      //.then((result) async {
      if (newUser != null) {
        QuerySnapshot userInfoSnapshot =
        await DatabaseMethods().getUserInfo(emailEditingController.text);

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.docs[0]["userName"]);
        HelperFunctions.saveUserEmailSharedPreference(
            userInfoSnapshot.docs[0]["email"]);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom())
        );
      }
      else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('⚡ChatApp'),
        elevation: 0.0,
        centerTitle: false,
        actions: [
      GestureDetector(
            onTap: () {},
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SvgPicture.asset(
                  "images/message.svg",
                  height: 22,
                ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
        )
          : Container(
        //padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                            ? null
                            : "Please Enter Correct Email";
                      },
                      controller: emailEditingController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Email',prefixIcon: Icon(Icons.email,color: Colors.blueAccent)),
                    ),
                    TextFormField(
                      obscureText: true,
                        controller: passwordEditingController,
                      validator: (val) {
                        return val!.length > 6
                            ? null
                            : "Enter Password 6+ characters";
                      },
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Password',prefixIcon: Icon(Icons.visibility_off,color: Colors.blueAccent))
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      /**Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));**/
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        )
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Log In",
                    style: biggerTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                      style: TextStyle(
                        color: Colors.white70, fontSize: 16,
                      ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}