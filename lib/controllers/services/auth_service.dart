import 'dart:developer' show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // final _googleSignIn = GoogleSignIn();
  // GoogleSignInAccount? _gUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _authErrorMsg = '';
  String get errorMsg => _authErrorMsg;

  // GoogleSignInAccount get gUser => _gUser!;

  // Future googleLogin() async {
  //   log('g-loggin');
  //   final googleUser = await _googleSignIn.signIn();
  //   if (googleUser == null) return;
  //   _gUser = googleUser;

  //   final googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   try {
  //     final auth = await _firebaseAuth.signInWithCredential(credential);
  //     log(auth.user!.uid);
  //     log(auth.user!.displayName!);
  //   } on FirebaseAuthException catch (e) {
  //     _authErrorMsg = e.message!;
  //     log(_authErrorMsg);
  //   }
  // }

  Future<void> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      // _isLoading = true;
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      if (user != null) {
        user.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains('An internal error')) {
        _authErrorMsg = 'An internal error occurred.\nPlease try again';
      } else if (e.message!.contains(
          'A network error (such as timeout, interrupted connection or unreachable host)')) {
        _authErrorMsg = 'network error';
      } else if (e.code == 'weak-password') {
        _authErrorMsg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _authErrorMsg = 'The account already exists for that email.';
      } else {
        _authErrorMsg = e.message!;
      }
      log(_authErrorMsg);
      // _isLoading = false;
    }
  }

  void login(String email, String password) async {
    try {
      log('login');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        log(user.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains(
              'There is no user record corresponding to this identifier') ||
          e.message!.contains(
              'The password is invalid or the user does not have a password')) {
        _authErrorMsg = 'Invalid E-mail or Password';
      } else if (e.message!.contains('An internal error')) {
        _authErrorMsg = 'An internal error occurred.\nPlease try again';
      } else if (e.code == 'user-not-found') {
        _authErrorMsg = 'No user found for that email.';
      } else if (e.message!.contains(
          'A network error (such as timeout, interrupted connection or unreachable host)')) {
        _authErrorMsg = 'network error';
      } else {
        _authErrorMsg = e.message!;
      }
      // state = AuthStateError(_authErrorMsg);
      log(_authErrorMsg);
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      _authErrorMsg = e.message!;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
