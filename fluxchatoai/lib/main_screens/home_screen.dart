import 'package:flutter/material.dart';
import 'package:fluxchatoai/main_screens/chat_screen.dart';
import 'package:fluxchatoai/main_screens/posts_screen.dart';
import 'package:fluxchatoai/main_screens/profile_screen.dart';
import 'package:fluxchatoai/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs = [
    const ChatScreen(),
    const PostsScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    Color color = themeStatus.themeType ? Colors.white : Colors.black;
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: color,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Chat',),
          BottomNavigationBarItem(icon: Icon(Icons.add_outlined), label: 'Posts',),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile',),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
