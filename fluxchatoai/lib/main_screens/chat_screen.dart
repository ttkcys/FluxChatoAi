import 'package:flutter/material.dart';
import 'package:fluxchatoai/providers/theme_provider.dart';
import 'package:fluxchatoai/widgets/bottom_chat_field.dart';
import 'package:fluxchatoai/widgets/chat_list.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).themeType;
    Color color = isDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Flux Chato AI',
          style: TextStyle(
              color: color),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatList(),
            ),

            const SizedBox(height: 10,),

            BottomChatField(),
          ],
        ),
      ),
    );
  }
}
