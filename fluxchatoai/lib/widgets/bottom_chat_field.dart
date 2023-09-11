import 'package:flutter/material.dart';
import 'package:fluxchatoai/constants/constants.dart';
import 'package:fluxchatoai/providers/auth_provider.dart';
import 'package:fluxchatoai/providers/chat_provider.dart';
import 'package:fluxchatoai/providers/theme_provider.dart';
import 'package:fluxchatoai/utility/utility.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).themeType;
    Color color = isDarkTheme ? Colors.white : Colors.black;
    return Column(
      children: [
        // Üst kısım çizgisi
        Container(
          height: 4.0, // Çizgi kalınlığı
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            gradient: LinearGradient(
              colors: [
                Color(0x807F3F98), // Başlangıç rengi
                Color(0xFF2B7BBB), // Bitiş rengi
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        Material(
          color: isDarkTheme ? Constants.fluxChatDarkCardColor : Colors.white70,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textEditingController,
                    style: TextStyle(color: color),
                    decoration: InputDecoration.collapsed(
                      hintText: 'How can I help?',
                      hintStyle: TextStyle(
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                    showSnackBar(
                        context: context, content: 'Please type a message...');
                    return;
                  }
                  context.read<ChatProvider>().sendMessage(
                      uid: context.read<AuthProvider>().userModel!.uid,
                      message: textEditingController.text,
                      modelId: '',
                      onSuccess: (){
                        print('success');
                      },
                      onCompleted: (){
                        print('success');
                      },
                  );
                },
                icon: Icon(
                  Icons.send_outlined,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
