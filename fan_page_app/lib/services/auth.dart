// import 'dart:html';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import './helperfuncs.dart';
import '../services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => null;
  User1? _userfromfirebaseUser(user) {
    // return user != null ? User1(uid: user.uid) : null;
    if (user == null) {
      return null;
    } else {
      return User1(uid: user.uid);
    }
  }

  Stream<User1?> get user {
    return _auth.authStateChanges().map(_userfromfirebaseUser);

    // return FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     return null;
    //   } else {
    //     return User1(uid: user.uid);
    //   }
    // });

    // ((event) { }) map(_userfromfirebaseUser);
  }

  Future signwithEMail(String email, String password) async {
    try {
      var res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // DatabaseServices databaseService = new DatabaseServices();

      var user = res.user;
      return _userfromfirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future regwithEmail(String email, String password) async {
    try {
      var res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = res.user;
      return _userfromfirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await helperFunctions.saveUserFNameSharedPreference('');
      await helperFunctions.saveUserLNameSharedPreference('');
      await helperFunctions.saveUserEmailSharedPreference('');
      await helperFunctions.saveUserLoggedInSharedPreference(false);
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  signInWithCredential(AuthCredential credential) {}
}
