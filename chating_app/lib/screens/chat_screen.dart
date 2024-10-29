import 'package:chating_app/chatting/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import '../chatting/chat/message.dart';
import '../chatting/chat/new_message.dart';
import 'main_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentification=FirebaseAuth.instance;
  User? loggedUser;

  void getCurrentUser(){
    try
    {

      final user=_authentification.currentUser;
      if(user!=null)
      {
        loggedUser=user;
        print(loggedUser!.email);
      }
    }catch(e)
    {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("chat"),
        actions: [
          IconButton(
              onPressed:(){
                _authentification.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context){
                      return LoginSignScreen();
                    }),
                    (route)=>false);
                print("logout");
              },
              icon: Icon(Icons.exit_to_app_sharp))
        ],
      ),
      body:Container(
        child: Column(

          children: [
            Expanded(child: ChateMessages()),
            SendMessage(),

          ],
        )
      )
    );
  }
}

class Messages {
}
