import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kpathshala/api/api_container.dart';

import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/login_signup_page/otp_verify_page.dart';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends StatefulWidget {
  final String? deviceId;
  final bool isFromGmailOrFacebookLogin;

  const Profile({
    super.key,
    this.deviceId,
    this.isFromGmailOrFacebookLogin = false,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  String? _networkImageUrl;
  final AuthService _authService = AuthService();
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  bool isNumberFieldActive = true;

  @override
  void initState() {
    super.initState();
    readCredentials();
  }

  void readCredentials() async {
    LogInCredentials? credentials = await _authService.getLogInCredentials();

    if (credentials != null) {
      _nameController.text = credentials.name ?? "";
      _emailController.text = credentials.email ?? "";
      _mobileController.text = credentials.mobile ?? "";
      _networkImageUrl = credentials.imagesAddress ?? "";
      if (credentials.mobile.isNotEmptyAndNotNull) {
        isNumberFieldActive = false;
      }
      setState(() {});
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credentials found")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) => bottomSheet(),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Choose Profile photo", style: TextStyle(fontSize: 20.0)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                _takePhoto(ImageSource.camera);
                Navigator.of(context).pop();
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                _takePhoto(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              label: const Text("Gallery"),
            ),
          ]),
        ],
      ),
    );
  }

  void _takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => _showImagePicker(context),
                  child: _imageFile == null
                      ? CircleAvatar(
                          radius: 90,
                          backgroundImage: _networkImageUrl != null
                              ? NetworkImage(_networkImageUrl!)
                              : null,
                        )
                      : CircleAvatar(
                          radius: 90,
                          backgroundImage: FileImage(_imageFile!),
                        ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _nameController,
                  label: "Full Name",
                  errorMessage: _nameError,
                  onChanged: (_) {
                    if (_nameController.text.isNotEmpty) {
                      _nameError = null;
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 15),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      controller: _mobileController,
                      label: "Phone Number",
                      errorMessage: _phoneError,
                      isEnabled: isNumberFieldActive,
                    ),
                    Positioned(
                      right: 8.0,
                      child: InkWell(
                        onTap: widget.isFromGmailOrFacebookLogin
                            ? () {
                                if (_validateFields()) {
                                  sendOtp(
                                    mobileNumber: _mobileController.text,
                                    email: _emailController.text,
                                  );
                                }
                              }
                            : null,
                        borderRadius: BorderRadius.circular(32.0),
                        splashColor: Colors.blueAccent.withOpacity(0.2),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: widget.isFromGmailOrFacebookLogin
                                ? AppColor.navyBlue
                                : AppColor.verified,
                            borderRadius: BorderRadius.circular(32.0),
                            boxShadow: widget.isFromGmailOrFacebookLogin
                                ? const [
                                    BoxShadow(
                                      color: AppColor.skyBlue,
                                      blurRadius: 0.0,
                                      offset: Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: widget.isFromGmailOrFacebookLogin
                              ? const Text(
                                  'Verify phone',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                )
                              : const Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 14,
                                      color: AppColor.white,
                                    ),
                                    Gap(2),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: AppColor.white),
                                    ),
                                    Gap(4),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: _emailController,
                  label: "Email",
                  errorMessage: _emailError,
                  onChanged: (_) {
                    if (_emailController.text.isNotEmpty) {
                      _emailError = null;
                      setState(() {});
                    }
                  },
                  isEnabled: !widget.isFromGmailOrFacebookLogin,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 55,
                  width: 320,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateFields()) {
                        updateProfile(
                          context: context, // Pass the context here
                          name: _nameController.text,
                          email: _emailController.text,
                          imageFile: _imageFile,
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    setState(() {
      _nameError =
          _nameController.text.isEmpty ? "Full Name is required" : null;

      _phoneError =
          _mobileController.text.isEmpty ? "Phone Number is required" : null;

      final email = _emailController.text;
      if (email.isEmpty) {
        _emailError = "Email is required";
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email)) {
        _emailError = "Please enter a valid email address";
      } else {
        _emailError = null;
      }
    });

    return _nameError == null && _phoneError == null && _emailError == null;
  }

  void sendOtp({required String mobileNumber, required String email}) async {
    showLoadingIndicator(context: context, showLoader: true);
    if (mobileNumber.isEmpty) {
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your mobile number.")),
      );
      return;
    }
    final response = await _authService.sendOtp(mobileNumber, email: email);
    log(jsonEncode(response));
    if (response['error'] == null || !response['error']) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);

        slideNavigationPush(
            OtpPage(
              mobileNumber: mobileNumber,
            ),
            context);
      }
    } else {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP: ${response['message']}")),
        );
      }
    }
  }

  Future<void> updateProfile({
    required BuildContext context,
    required String name,
    required String email,
    File? imageFile,
    String? networkImageUrl,
  }) async {
    showLoadingIndicator(context: context, showLoader: true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    if (token.isEmpty) {
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You need to log in again.")),
      );
      return;
    }

    final request = http.MultipartRequest(
        'POST', Uri.parse(AuthorizationEndpoints.userUpdate));

    request.headers['Authorization'] =
        'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    } else if (networkImageUrl != null && networkImageUrl.isNotEmpty) {
      request.fields['image_url'] = networkImageUrl;
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      log('Raw Response: $responseBody');
      final responseJson = jsonDecode(responseBody);
      log('Parsed Response: $responseJson');
      showLoadingIndicator(context: context, showLoader: false);
      if (response.statusCode == 200) {
        if (responseJson['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(responseJson['message'] ??
                    "Profile updated successfully.")),
          );
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => Navigation()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(responseJson['message'] ?? "Something went wrong")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to update profile: ${response.statusCode}")),
        );
      }
    } catch (e) {
      // Handle JSON parsing error
      log('Error parsing response: $e');
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while updating profile")),
      );
    }
  }

// Helper method to show loading indicator
  void showLoadingIndicator(
      {required BuildContext context, required bool showLoader}) {
    if (showLoader) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );
    } else {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Close the loading indicator
    }
  }
}
