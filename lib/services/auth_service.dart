import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fureverhome/views/main_base.dart';
import 'package:fureverhome/views/user_detail_form.dart';
import '../views/auth/login.dart';
import '../business_logic/user_service.dart';
import '../models/user_detail.dart';

class AuthService {

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      if (user.user != null) {
        await UserService().addNewUser(
          UserDetail(
            firebaseUid : user.user!.uid,
            name: "",
            phone: "",
            address: "",
          )
        );
      }
      
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => UserDetailsPage(email: email, password: password,)
        )
      );
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MainScreen()
        )
      );
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signout({
    required BuildContext context
  }) async {
    
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>Login()
        )
      );
  }
}