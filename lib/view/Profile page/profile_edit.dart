import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpathshala/sign_in_methods/sign_in_methods.dart';
import 'package:kpathshala/view/Login%20Signup%20Page/registration_and_login_page.dart';
import 'package:kpathshala/view/Profile%20page/utils.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/customTextField.dart';

class Profile extends StatefulWidget {
  final UserCredential? userCredential;
  final String? mobileNumber;

  const Profile({super.key, this.userCredential, this.mobileNumber});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? _image;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userCredential?.user?.displayName ?? "";
    _emailController.text = widget.userCredential?.user?.email ?? "";
    _phoneController.text = widget.mobileNumber ?? "";
  }

  @override
  void dispose() {
    [_nameController, _phoneController, _emailController].forEach((c) => c.dispose());
    super.dispose();
  }

  void selectImage() async {
    _image = await pickImage(ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider = _image != null
        ? MemoryImage(_image!)
        : const AssetImage('assets/new_App_icon.png') as ImageProvider<Object>;

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              customText('Edit profile', TextType.title, fontSize: 18, color: AppColor.cancelled),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(radius: 90, backgroundImage: imageProvider),
                  Positioned(
                    bottom: 0, left: 46,
                    child: ElevatedButton.icon(
                      onPressed: selectImage,
                      label: const Text('Add', style: TextStyle(color: Colors.black, fontSize: 15)),
                      icon: const Icon(Icons.add, color: Colors.black, size: 18),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              customTextField(controller: _nameController, label: "Full Name", width: 300.0, height: 50.0),
              const SizedBox(height: 15),
              customTextField(controller: _phoneController, label: "Phone Number", width: 300.0, height: 50.0),
              const SizedBox(height: 15),
              customTextField(controller: _emailController, label: "Email", width: 300.0, height: 50.0),
              const SizedBox(height: 30),
              SizedBox(
                height: 55,
                width: 320,
                child: ElevatedButton(
                  onPressed: () {
                    // Add save functionality here
                  },
                  child: const Text('Save'),
                ),
              ),
              TextButton(
                onPressed: () => slideNavigationPush(const RegistrationPage(title: 'Sign Up'), context),
                child: const Text("SignUp"),
              ),
              TextButton(
                onPressed: () {
                  SignInMethods.logout();
                  [_nameController, _emailController].forEach((c) => c.clear());
                },
                child: const Text("SignOut"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
