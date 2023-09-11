import 'package:flutter/material.dart';
import 'package:fluxchatoai/auth/registration.dart';
import 'package:fluxchatoai/providers/auth_provider.dart';
import 'package:fluxchatoai/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    Color color = themeStatus.themeType ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Flux Chato AI',
          style: TextStyle(
              color: color),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if(themeStatus.themeType) {
                themeStatus.setTheme = false;
              } else {
                themeStatus.setTheme = true;
              }
            },
            icon: Icon(
              themeStatus.themeType
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: color,
            ),
          ),
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().signOutUser();
              navigateToRegisterScreen();
            },
            icon: Icon(
              Icons.logout_outlined,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void navigateToRegisterScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
            (route) => false);
  }
}
