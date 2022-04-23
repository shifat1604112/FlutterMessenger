import 'package:messenger_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:messenger_flutter/screens/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_flutter/screens/chatrooms.dart';
import 'package:messenger_flutter/services/database.dart';
import 'package:messenger_flutter/helper/helperfunctions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  final Function toggleView;
  RegistrationScreen(this.toggleView);


  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  bool isLoading = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚡Register. . . '),
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
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) :  Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Spacer(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(
                      color: Colors.white,fontSize: 16,
                    ),
                    controller: usernameEditingController,
                    validator: (val){
                      return val!.isEmpty || val!.length < 3 ? "Enter Username 3+ characters" : null;
                    },
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Username ',prefixIcon: Icon(Icons.title,color: Colors.blueAccent)),
                  ),
                  TextFormField(
                    controller: emailEditingController,
                    style: TextStyle(
                    color: Colors.white,fontSize: 16,
                    ),
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                      null : "Enter correct email";
                    },
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Email ',prefixIcon: Icon(Icons.email,color: Colors.blueAccent)),
                  ),
                  TextFormField(
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.white,fontSize: 16,
                    ),
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Password ',prefixIcon: Icon(Icons.visibility_off,color: Colors.blueAccent)),
                    controller: passwordEditingController,
                    validator:  (val){
                      return val!.length < 7 ? "Enter Password 6+ characters" : null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                  if(formKey.currentState!.validate()){
                  setState(() {
                  isLoading = true;
                  });}
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: emailEditingController.text, password: passwordEditingController.text);
                  if(newUser!=null){

                    Map<String,String> userDataMap = {
                      "userName" : usernameEditingController.text,
                      "email" : emailEditingController.text
                    };
                    databaseMethods.addUserInfo(userDataMap);

                    HelperFunctions.saveUserLoggedInSharedPreference(true);
                    HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
                    HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => ChatRoom()
                    ));
                  }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [const Color(0xff007EF4), const Color(0xff2A75BC)],
                    )),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Sign Up",
                  style: biggerTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Colors.white,fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    "Sign In now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
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
