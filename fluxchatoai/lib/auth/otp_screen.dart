  import 'package:flutter/material.dart';
  import 'package:fluxchatoai/auth/user_information_screen.dart';
  import 'package:fluxchatoai/providers/auth_provider.dart';
  import 'package:fluxchatoai/service/assets_manager_service.dart';
  import 'package:pinput/pinput.dart';
  import 'package:provider/provider.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  import '../main_screens/home_screen.dart';
  import '../utility/utility.dart';

  class OTPScreen extends StatefulWidget {
    final String verificationId;

    const OTPScreen({super.key, required this.verificationId});

    @override
    State<OTPScreen> createState() => _OTPScreenState();
  }

  class _OTPScreenState extends State<OTPScreen> {
    TextEditingController otpController = TextEditingController();
    String? smsCode;

    @override
    Widget build(BuildContext context) {
      final authRepo = Provider.of<AuthProvider>(context, listen: true);
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
                      height: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            AssetImage(AssetsManagerService.fluxChatLogo),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Please enter the verification code sent to your phone number.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Pinput(
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                            color: const Color(0xFF7F3F98),
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onCompleted: (value) {
                        smsCode = value;
                        completeVerification(widget.verificationId, smsCode!);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    authRepo.isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF7F3F98),
                          )
                        : const SizedBox.shrink(),
                    authRepo.isSuccessful
                        ? Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.check_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'Didn\'t receive any code?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    void completeVerification(String verificationId, String smsCode) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (authResult.user != null) {
          // 1. Check if the current user exists in the database
          bool userExists = await authProvider.checkUserExist();

          if (userExists) {
            // 2. Get user data from the database
            await authProvider.getUSerDataFromFireStore();

            // 3. Save user data to shared preferences
            await authProvider.saveUserDataToSharedPref();

            // 4. Set this user as signed in
            await authProvider.setSignedIn();

            // 5. Navigate to the Home screen
            navigate(isSignedIn: true);
          } else {
            // Navigate to the user information screen
            navigate(isSignedIn: false);
          }
        } else {
          showSnackBar(
              context: context, content: 'There are some mistakes.');
        }
      } catch (e) {
        print('Doğrulama hatası: $e');
      }
    }



    void navigate({required bool isSignedIn}) {
      if (isSignedIn) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserInformationScreen(),
          ),
        );
      }
    }
  }
