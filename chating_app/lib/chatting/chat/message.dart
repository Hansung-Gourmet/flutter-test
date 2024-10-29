import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_bubble.dart';

class ChateMessages extends StatefulWidget {
  const ChateMessages({super.key});

  @override
  State<ChateMessages> createState() => _MessagesState();
}

class _MessagesState extends State<ChateMessages> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
                                .collection("chat")
                                .orderBy("time",descending: true)
                                .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          var docs=snapshot.data!.docs;


          return ListView.builder(
            reverse: true,
              itemBuilder: (context,index)
            {
              bool userCheck=FirebaseAuth.instance.currentUser!.uid==docs[index]["userId"]? true :false;
              
              return ChatBubble(msg: docs[index]["text"],isMe:userCheck);
            },
              itemCount: docs.length
            ,

          );

      },
        );
  }
}
