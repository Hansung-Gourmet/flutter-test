import 'package:flutter/material.dart';


class ChatBubble extends StatelessWidget {
  final String msg;
  final bool isMe;

  const ChatBubble({super.key,required this.msg,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [

          Container(
            decoration: BoxDecoration(
              color: isMe? Colors.blue : Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            width: 145,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4,horizontal: 20),
            child: Text(msg,
            style: TextStyle(
              color: Colors.white
            ),
              ),
          )


      ],
    );
  }
}
