import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<SendMessage> {
  bool _enable_click=false;
  String msg="";
  final controller=TextEditingController();

  void sendMsg(){
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection("chat")
        .add({"text":msg , "time" : Timestamp.now(),"userId":FirebaseAuth.instance.currentUser!.uid});

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.all(8),  // 대신 패딩 추가
      child: Row(
        children: [
          Expanded(child: TextField(
            maxLines: null,
            controller: controller,
            decoration: InputDecoration(
              labelText: "Sned a message.."
            ),
            onChanged: (value){
              if(value.length>0)
                {
                  setState(() {
                    _enable_click=true;
                    msg=value;
                  });
                }
              else
                {
                  setState(() {
                    _enable_click=false;
                    msg=value;
                  });
                }
            },
          )),
          IconButton(
            color: Colors.blue,
            onPressed: _enable_click? sendMsg: null,

             icon: Icon(Icons.send)
            ,
          )

        ],
      ),
    );
  }
}
