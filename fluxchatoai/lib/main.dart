import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluxchatoai/auth/landing_screen.dart';
import 'package:fluxchatoai/auth/registration.dart';
import 'package:fluxchatoai/auth/user_information_screen.dart';
import 'package:fluxchatoai/constants/constants.dart';
import 'package:fluxchatoai/firebase_options.dart';
import 'package:fluxchatoai/main_screens/home_screen.dart';
import 'package:fluxchatoai/providers/auth_provider.dart';
import 'package:fluxchatoai/providers/chat_provider.dart';
import 'package:fluxchatoai/providers/theme_provider.dart';
import 'package:fluxchatoai/themes/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ChatProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  getCurrentTheme() async {
    await Provider.of<ThemeProvider>(context, listen: false).getThemeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flux Chato AI',
          theme:
              Themes.themeData(isDarkTheme: value.themeType, context: context),
          initialRoute: Constants.landingScreen,
          routes: {
            Constants.landingScreen: (context) => const LandingScreen(),
            Constants.registrationScreen: (context) => const RegistrationScreen(),
            Constants.homeScreen: (context) => const HomeScreen(),
            Constants.userInformationScreen: (context) => const UserInformationScreen(),
          },
        );
      },
    );
  }
}
