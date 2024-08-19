import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpathshala/view/Profile_edit/utils.dart';
import 'package:kpathshala/view/common_widget/customTextField.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? _image;

  // Create controllers for each input field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  void dispose() {
    // Dispose of controllers when no longer needed
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the appropriate image provider
    ImageProvider<Object> imageProvider;
    if (_image != null) {
      imageProvider = MemoryImage(_image!) as ImageProvider<Object>;
    } else {
      imageProvider = AssetImage('assets/logo.png') as ImageProvider<Object>;
    }

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
                      radius: 90,
                      backgroundImage: imageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 46,
                      child: SizedBox(
                        height: 40,
                        width: 90,
                        child: ElevatedButton.icon(
                          onPressed: selectImage,
                          label: Text(
                            'Add',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          icon: Icon(
                            Icons.camera,
                            color: Colors.black,
                            size: 15,
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
              SizedBox(height: 30),
              SizedBox(
                height: 53,
                width: 360,
                child: customTextField(
                    controller: _nameController,
                    label: "Full Name",
                    hintText: ''),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 53,
                width: 360,
                child: customTextField(
                    controller: _phoneController,
                    label: "Phone Number",
                    hintText: ''),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 53,
                width: 360,
                child: customTextField(
                    controller: _emailController, label: "Email", hintText: ''),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: SizedBox(
                  height: 54,
                  width: 380,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add save functionality here
                    },
                    child: Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
