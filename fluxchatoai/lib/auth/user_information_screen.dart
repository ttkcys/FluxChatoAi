import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluxchatoai/main_screens/home_screen.dart';
import 'package:fluxchatoai/models/user_model.dart';
import 'package:fluxchatoai/providers/auth_provider.dart';
import 'package:fluxchatoai/service/assets_manager_service.dart';
import 'package:fluxchatoai/utility/utility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  File? finalImageFile;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final phoneNumber = authProvider.phoneNumber;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      phoneController.text = phoneNumber!;
    }
  }


  void selectImage(bool fromCamera) async {
    finalImageFile = await pickImage(context: context, fromCamera: fromCamera);

    if (finalImageFile != null) {
      cropImage(finalImageFile!.path);
    }
  }


  void popThePickImageDialog() {
    Navigator.pop(context);
  }

  void cropImage(filePath) async {
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 800, maxWidth: 800);

    popThePickImageDialog();

    if (croppedFile != null) {
      setState(() {
        finalImageFile = File(croppedFile.path);
      });
    }
  }

  void showImagePickerDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Please choose an option',
              style: TextStyle(fontSize: 24),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    selectImage(true);
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF7F3F98),
                          size: 30,
                        ),
                      ),
                      Text(
                        'Camera',
                        style:
                            TextStyle(color: Color(0xFF2B7BBB), fontSize: 20),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    selectImage(false);
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.image_outlined,
                          color: Color(0xFF2B7BBB),
                          size: 30,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style:
                            TextStyle(color: Color(0xFF7F3F98), fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 35),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: finalImageFile == null
                          ? Stack(
                              children: [
                                CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      AssetImage(AssetsManagerService.userIcon),
                                  backgroundColor: Colors.transparent,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 2,
                                        color: const Color(0xFF7F3F98),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Color(0xFF2B7BBB),
                                        ),
                                        onPressed: () {
                                          showImagePickerDialog();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      FileImage(File(finalImageFile!.path)),
                                  backgroundColor: Colors.transparent,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 2,
                                        color: const Color(0xFF7F3F98),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Color(0xFF2B7BBB),
                                        ),
                                        onPressed: () {
                                          showImagePickerDialog();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        myTextFormField(
                          hintText: 'Enter your name',
                          icon: Icons.account_circle_outlined,
                          textInputType: TextInputType.name,
                          maxLines: 1,
                          maxLength: 25,
                          textEditingController: nameController,
                          enabled: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        myTextFormField(
                          hintText: 'Enter your phone number',
                          icon: Icons.phone_outlined,
                          textInputType: TextInputType.number,
                          maxLines: 1,
                          maxLength: 13,
                          textEditingController: phoneController,
                          enabled: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: RoundedLoadingButton(
                      onPressed: () {
                        saveUserDataToFireStore();
                      },
                      controller: btnController,
                      successIcon: Icons.check_outlined,
                      successColor: Colors.green,
                      errorColor: Colors.red,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7F3F98), Color(0xFF2B7BBB)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color:
                                  Colors.white, // Text color inside the button
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myTextFormField({
    required String hintText,
    required IconData icon,
    required TextInputType textInputType,
    required int maxLines,
    required int maxLength,
    required TextEditingController textEditingController,
    required bool enabled,
  }) {
    return TextFormField(
      enabled: enabled,
      cursorColor: Colors.orange,
      controller: textEditingController,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xFF2B7BBB),),
          margin: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        hintText: hintText,
        alignLabelWithHint: true,
        border: InputBorder.none,
        fillColor: Color(0x807F3F98),
        filled: true,
      ),
    );
  }

  Future<void> saveUserDataToFireStore() async {
    final authProvider = context.read<AuthProvider>();
    UserModel userModel = UserModel(
      uid: authProvider.uid ?? '',
      name: nameController.text.trim(),
      profilePic: '',
      phone: phoneController.text,
      aboutMe: '',
      lastSeen: '',
      dateJoined: '',
      isOnline: true,
    );

    if (finalImageFile != null) {
      if (nameController.text.length >= 3) {
        authProvider.saveUserDataToFireStore(
          context: context,
          userModel: userModel,
          fileImage: finalImageFile!,
          onsSuccess: () async {
            await authProvider.saveUserDataToSharedPref();

            await authProvider.setSignedIn();

            navigateToHomeScreen();
          },
        );
      } else {
        btnController.reset();
        showSnackBar(
          context: context,
          content: 'Name must be at least 3 characters.',
        );
      }
    } else {
      btnController.reset();
      showSnackBar(context: context, content: 'Please select an image');
    }
  }


  void navigateToHomeScreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
  }
}
