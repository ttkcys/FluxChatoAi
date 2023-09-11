import 'package:flutter/material.dart';
import 'package:fluxchatoai/auth/registration.dart';
import 'package:fluxchatoai/main_screens/home_screen.dart';
import 'package:fluxchatoai/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isSignedIn = await authProvider.checkSignedIn();

    if (isSignedIn) {
      await authProvider.getUSerDataFromFireStore();
      await authProvider.getUserDataFromSharedPref();
    }

    setState(() {
      _isLoading = false;
    });

    navigate(isSignedIn: isSignedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(
          color: Colors.deepOrangeAccent,
        )
            : Container(),
      ),
    );
  }

  void navigate({required bool isSignedIn}) {
    if (isSignedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
            (route) => false,
      );
    }
  }
}
