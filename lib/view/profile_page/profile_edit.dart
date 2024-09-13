import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:kpathshala/model/api_response_models/user_update_success_response.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/login_signup_page/otp_verify_page.dart';
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';
import 'package:kpathshala/view/profile_page/utils.dart';
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
  Uint8List? _image;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  String? _networkImageUrl;
  final AuthService _authService = AuthService();
  String? _nameError;
  String? _phoneError;
  String? _emailError;

  bool isNumberFieldActive = true;

  // File? image;

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
      if (credentials.mobile.isNotEmptyAndNotNull){
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

  void selectImage(ImageSource source) async {
    _image = await pickImage(source);
    setState(() {});
  }

  //   void selectImage(ImageSource source) async {
  //   XFile? pickedFile = await ImagePicker().pickImage(source: source);
  //   if (pickedFile != null) {
  //     cropImage(pickedFile);
  //   }
  // }

  // void cropImage(XFile file) async {
  //   CroppedFile? croppedImage = await ImageCropper()
  //       .cropImage(sourcePath: file.path, compressQuality: 20);

  //   if (croppedImage != null) {
  //     setState(() {
  //       image = File(croppedImage.path);
  //     });
  //   }
  // }

  //   void postData() async {
  //   try {
  //     // Prepare data for request
  //     String? imageExtension = image?.path.split('.').last;
  //     String jsonData = jsonEncode(widget.isEditMode ? dataEdit : data);
  //     log(jsonData.toString());
  //     FormData formData = FormData.fromMap({
  //       'Data': jsonData,
  //       'Image': image != null
  //           ? await MultipartFile.fromFile(
  //         image!.path,
  //         filename:
  //         '${DateTime.now().millisecondsSinceEpoch}.$imageExtension',
  //       )
  //           : null,
  //     });

  //     if (mounted) {
  //       if (response.statusCode == 200 && response.isSucceeded) {
  //         showSnackBar(response.getMessage, true, context);
  //       } else {
  //         showSnackBar(
  //           response.getMessage,
  //           false,
  //           context,
  //           isFromPermission: response.isContainPermission,
  //         );
  //       }
  //       Navigator.pop(context); // Safely pop the Navigator after async operations
  //     }
  //   } catch (e) {
  //     log('Error while saving data: $e');
  //     if (mounted) {
  //       showSnackBar('Error while saving data', false, context);
  //     }
  //   }
  // }

  //   void showPhotoOption() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Upload Image"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 selectImage(ImageSource.gallery);
  //               },
  //               leading: const Icon(Icons.photo_album_rounded),
  //               title: const Text("Select from Gallery"),
  //             ),
  //             ListTile(
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 selectImage(ImageSource.camera);
  //               },
  //               leading: const Icon(Icons.camera_alt),
  //               title: const Text("Take a Photo"),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void showImageSourceOptions() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => Wrap(
  //       children: [
  //         ListTile(
  //           leading: const Icon(Icons.photo_library),
  //           title: const Text('Gallery'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             selectImage(ImageSource.gallery);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.camera_alt),
  //           title: const Text('Camera'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             selectImage(ImageSource.camera);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider;

    if (_networkImageUrl.isNotEmptyAndNotNull) {
      imageProvider = NetworkImage(_networkImageUrl ?? '');
    } else if (_image != null) {
      imageProvider = MemoryImage(_image!);
    } else {
      imageProvider = const AssetImage('assets/new_App_icon.png');
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
                const SizedBox(height: 80),
                customText('Edit profile', TextType.title,
                    fontSize: 18, color: AppColor.cancelled),
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 200,
                    ),
                    CircleAvatar(radius: 90, backgroundImage: imageProvider),
                    Positioned(
                      bottom: 0,
                      child: ElevatedButton.icon(
                        onPressed: () {},
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
                        updateProfile(
                          name: _nameController.text,
                          email: _emailController.text,
                          image: _networkImageUrl ?? '',
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
    required String image,
  }) async
  {
    // Show loading indicator
    showLoadingIndicator(context: context, showLoader: true);

    try {
      final response =
          await _authService.userUpdate(name: name, email: email, image: image);
      log(jsonEncode(response));

      // Hide loading indicator and handle navigation or error display
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);

        if (response['error'] == null || !response['error']) {
          final apiResponse = UserUpdateSuccessResponse.fromJson(response);
          LogInCredentials? credentials =
              await _authService.getLogInCredentials();
          final newName = apiResponse.data?.name ?? '';
          final newEmail = apiResponse.data?.email ?? '';
          final newMobile = apiResponse.data?.mobile ?? '';
          final newImage = apiResponse.data?.image ?? '';

          if (credentials != null) {
            credentials.name = newName;
            credentials.email = newEmail;
            credentials.mobile = newMobile;
            credentials.imagesAddress = newImage;

            // Save the updated object back to SharedPreferences
            await _authService.saveLogInCredentials(credentials);
          } else {
            log("No credentials found to update");
          }
          if (mounted) {
            slideNavigationPushAndRemoveUntil(const Navigation(), context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to Update Profile: ${response['message']}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }
}
