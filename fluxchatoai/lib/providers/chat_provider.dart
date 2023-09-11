import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxchatoai/constants/constants.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  bool _isTyping = false;
  bool _isText = true;

  bool get isTyping => _isTyping;

  bool get isText => _isText;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String uid,
    required String message,
    required String modelId,
    required Function onSuccess,
    required Function onCompleted,
  }) async {
    try {
      _isTyping = true;
      notifyListeners();

      await sendMessageToFirestore(uid: uid, message: message);

      _isTyping = false;
      onSuccess();
    } catch (error) {
      _isTyping = false;
      notifyListeners();
      print(error);
    } finally {
      _isTyping = false;
      notifyListeners();
      onCompleted();
    }
  }

  Future<void> sendMessageToFirestore({
    required String uid,
    required String message,
  }) async {
    String chatId = const Uuid().v4();
    await firebaseFirestore
        .collection(Constants.chats)
        .doc(uid)
        .collection(Constants.fluxChatAIChats)
        .doc(chatId)
        .set({
      Constants.senderId: uid,
      Constants.chatId: chatId,
      Constants.message: message,
      Constants.messageTime: FieldValue.serverTimestamp(),
      Constants.isText: isText,
    });
  }
}
