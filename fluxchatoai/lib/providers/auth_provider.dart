import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxchatoai/auth/otp_screen.dart';
import 'package:fluxchatoai/constants/constants.dart';
import 'package:fluxchatoai/models/user_model.dart';
import 'package:fluxchatoai/utility/utility.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccessful = false;
  bool _isSignedIn = false;

  String? _uid;
  String? _phoneNumber;

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  String? get uid => _uid;

  String? get phoneNumber => _phoneNumber;

  bool get isSuccessful => _isSuccessful;

  bool get isLoading => _isLoading;

  bool get isSignedIn => _isSignedIn;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
    required RoundedLoadingButtonController btnController,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          _phoneNumber = phoneNumber;
          //_uid = FirebaseAuth.instance.currentUser?.uid;
          btnController.success();

          Future.delayed(const Duration(seconds: 1)).whenComplete(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  verificationId: verificationId,
                ),
              ),
            );
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseException catch (e) {
      btnController.reset();
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      User? user =
          (await firebaseAuth.signInWithCredential(phoneAuthCredential)).user;

      if (user != null) {
        _uid = user.uid;
        notifyListeners();
        onSuccess();
      }

      _isLoading = false;
      _isSuccessful = true;
      notifyListeners();
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  Future<void> saveUserDataToFireStore({
    required BuildContext context,
    required UserModel userModel,
    required File fileImage,
    required Function onsSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String imageUrl = await storeFileImageToStorage(
          '${Constants.userImages}/$_uid.jpg', fileImage);
      userModel.profilePic = imageUrl;
      userModel.lastSeen = DateTime.now().microsecondsSinceEpoch.toString();
      userModel.dateJoined =
          DateTime.now().microsecondsSinceEpoch.toString();

      await firebaseFirestore
          .collection(Constants.users)
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onsSuccess();
        _isLoading = false;
        notifyListeners();
      });
        } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<String> storeFileImageToStorage(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<bool> checkUserExist() async {
    DocumentSnapshot documentSnapshot =
    await firebaseFirestore.collection(Constants.users).doc(_uid).get();

    return documentSnapshot.exists;
  }

  Future<void> getUSerDataFromFireStore() async {
    await firebaseFirestore
        .collection(Constants.users)
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      _userModel = UserModel(
        uid: documentSnapshot[Constants.uid],
        name: documentSnapshot[Constants.name],
        profilePic: documentSnapshot[Constants.profilePic],
        phone: documentSnapshot[Constants.phone],
        aboutMe: documentSnapshot[Constants.aboutMe],
        lastSeen: documentSnapshot[Constants.lastSeen],
        dateJoined: documentSnapshot[Constants.dateJoined],
        isOnline: documentSnapshot[Constants.isOnline],
      );
      _uid = _userModel!.uid;
      notifyListeners();
    });
  }

  Future<void> saveUserDataToSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_userModel != null) {
      await sharedPreferences.setString(
          Constants.userModel, jsonEncode(_userModel!.toMap()));
    }
  }


  Future<void> getUserDataFromSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString(Constants.userModel) ?? '';

    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;

    notifyListeners();
  }

  Future<void> setSignedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(Constants.isSignedIn, true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<bool> checkSignedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool(Constants.isSignedIn) ?? false;
    notifyListeners();
    return _isSignedIn;
  }

  Future<void> signOutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await firebaseAuth.signOut();
    _isSignedIn = false;
    sharedPreferences.clear();
    notifyListeners();
  }
}
