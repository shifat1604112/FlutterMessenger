import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger_flutter/helper/authenticate.dart';
import 'package:messenger_flutter/helper/helperfunctions.dart';
import 'package:messenger_flutter/screens/chatrooms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatefulWidget {
  @override
  _FlashChatState createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {

  bool? userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Messenger2.0',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.black38,
          primarySwatch: Colors.lightGreen,
        ),
        home: userIsLoggedIn != null ?  userIsLoggedIn! ? ChatRoom() : Authenticate()
            : Container(
          child: Center(
            child: Authenticate(),
          ),
        )
    );
  }
}
