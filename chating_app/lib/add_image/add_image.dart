import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AddImage extends StatefulWidget {
  const AddImage({super.key});


  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File? pickedImage;

  void pickImage()async{
    final imagePicker=ImagePicker();
    final pickImagedFile=await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 150,
    );

    setState(() {
      if(pickImagedFile !=null)
        {
          pickedImage=File(pickImagedFile.path);
        }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      width: 150,
      height: 300,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            backgroundImage:  pickedImage !=null ? FileImage(pickedImage!):null,
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            icon:Icon(Icons.image),
            onPressed: (){
              pickImage();
            },
            label: Text("add icon"),
          ),
          SizedBox(
            height: 80,
          ),
          TextButton.icon(
              onPressed: (){
                Navigator.pop(context);
              },
              label: Text("close"),
              icon: Icon(Icons.close)
          )
        ],
      ),
    );
  }
}
