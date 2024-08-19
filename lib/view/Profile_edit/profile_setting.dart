import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpathshala/view/Profile_edit/utils.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              customText('Edit profile', TextType.title, fontSize: 18),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 130,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : NetworkImage(
                              'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=1024x1024&w=is&k=20&c=6XEZlH2FjqdpXUqjUK4y0LlWF6yViZVWn9HZJ-IR8gU=',
                            ) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 75,
                      child: SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton.icon(
                          onPressed: selectImage,
                          label: Text(
                            'Add',
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.camera,
                            color: Colors.black,
                            size: 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: TextFormField(
                  decoration:
                      InputDecoration(filled: true, fillColor: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  decoration:
                      InputDecoration(filled: true, fillColor: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  decoration:
                      InputDecoration(filled: true, fillColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
