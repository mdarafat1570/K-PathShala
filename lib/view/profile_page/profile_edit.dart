import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/model/api_response_models/user_update_success_response.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/login_signup_page/otp_verify_page.dart';
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends StatefulWidget {
  final String? deviceId;
  final bool isFromGmailOrFacebookLogin;

  const Profile(
      {super.key, this.deviceId, this.isFromGmailOrFacebookLogin = false});

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
    for (var c in [_nameController, _mobileController, _emailController]) {
      c.dispose();
    }
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
          ])
        ],
      ),
    );
  }

  void _takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void _takePhoto(ImageSource source) async {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        }
      });
    }

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _showImagePicker(context),
                  child: _imageFile == null
                      ? CircleAvatar(
                          radius: 90,
                          backgroundImage: NetworkImage(_networkImageUrl ?? ''))
                      : CircleAvatar(
                          radius: 90, backgroundImage: FileImage(_imageFile!)),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 200,
                    ),
                    CircleAvatar(radius: 90),
                    Positioned(
                      bottom: 0,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_validateFields()) {
                            updateProfile(
                              name: _nameController.text,
                              email: _emailController.text,
                              imageFile: _imageFile,
                            );
                          }
                        },
                        label: const Text('Add',
                            style:
                                TextStyle(color: Colors.black, fontSize: 12)),
                        icon: const Icon(Icons.camera_alt_rounded,
                            color: Colors.black, size: 14),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                      ),
                    ),
                  ],
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
                    }),
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
                        File? imageFile;
                        if (_networkImageUrl != null &&
                            _networkImageUrl!.isNotEmpty) {
                          imageFile = File(_networkImageUrl!);
                        }

                        updateProfile(
                          name: _nameController.text,
                          email: _emailController.text,
                          imageFile: imageFile,
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
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

  void updateProfile({
    required String name,
    required String email,
    File? imageFile,
  }) async {
    showLoadingIndicator(context: context, showLoader: true);

    try {
      // Create a multipart request for the updated profile
      var uri = Uri.parse(AuthorizationEndpoints.userUpdate);
      var request = http.MultipartRequest("POST", uri)
        ..fields['name'] = name
        ..fields['email'] = email;

      if (imageFile != null) {
        // Attach the image file to the request if it is not null
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          imageFile.path,
        ));
      }

      // Send the request
      var response = await request.send();

      // Handle the response from the server
      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseData);

        if (decodedResponse['error'] == null || !decodedResponse['error']) {
          final apiResponse =
              UserUpdateSuccessResponse.fromJson(decodedResponse);
          LogInCredentials? credentials =
              await _authService.getLogInCredentials();
          if (credentials != null) {
            credentials.name = apiResponse.data?.name ?? name;
            credentials.email = apiResponse.data?.email ?? email;
            credentials.imagesAddress = apiResponse.data?.image ?? '';

            // Save the updated object back to SharedPreferences
            await _authService.saveLogInCredentials(credentials);
          }
          slideNavigationPushAndRemoveUntil(const Navigation(), context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Failed to Update Profile: ${decodedResponse['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to Update Profile: HTTP ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      showLoadingIndicator(context: context, showLoader: false);
    }
  }
}
