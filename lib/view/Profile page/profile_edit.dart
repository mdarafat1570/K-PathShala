import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:kpathshala/model/api_response_models/user_update_success_response.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/sign_in_methods/sign_in_methods.dart';
import 'package:kpathshala/view/Login%20Signup%20Page/otp_verify_page.dart';
import 'package:kpathshala/view/Login%20Signup%20Page/registration_and_login_page.dart';
import 'package:kpathshala/view/Navigation%20bar%20Page/navigation_bar.dart';
import 'package:kpathshala/view/Profile%20page/utils.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/common_loadingIndicator.dart';
import 'package:kpathshala/view/common_widget/customTextField.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends StatefulWidget {

  final String? deviceId;
  final bool isFromGmailOrFacebookLogin;

  const Profile(
      {super.key,

      this.deviceId,
      this.isFromGmailOrFacebookLogin = false});

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
    } else {
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

  void showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              selectImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              selectImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              customText('Edit profile', TextType.title,
                  fontSize: 18, color: AppColor.cancelled),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(radius: 90, backgroundImage: imageProvider),
                  Positioned(
                    bottom: 0,
                    left: 46,
                    child: ElevatedButton.icon(
                      onPressed: showImageSourceOptions,
                      label: const Text('Add',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      icon:
                          const Icon(Icons.add, color: Colors.black, size: 18),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              customTextField(
                controller: _nameController,
                label: "Full Name",
                width: 300.0,
                height: 50,
                errorMessage: _nameError, // Show name validation error
              ),
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  customTextField(
                    controller: _mobileController,
                    label: "Phone Number",
                    width: 300.0,
                    height: 50.0,
                    errorMessage: _phoneError, // Show phone validation error
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
                                        fontSize: 11.0, color: AppColor.white),
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
              customTextField(
                controller: _emailController,
                label: "Email",
                width: 300.0,
                height: 50.0,
                errorMessage: _emailError,
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
              TextButton(
                onPressed: () => slideNavigationPush(
                    const RegistrationPage(title: 'Sign Up'), context),
                child: const Text("SignUp"),
              ),
              TextButton(
                onPressed: () {
                  SignInMethods.logout();
                  for (var c in [
                    _nameController,
                    _mobileController,
                    _emailController
                  ]) {
                    c.clear();
                  }
                },
                child: const Text("SignOut"),
              ),
            ],
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
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$").hasMatch(email)) {
        _emailError = "Please enter a valid Gmail address";
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
  }) async {
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
          LogInCredentials? credentials = await _authService.getLogInCredentials();
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
            print("No credentials found to update");
          }
          slideNavigationPushAndRemoveUntil(const Navigation(), context);
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
