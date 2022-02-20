import 'package:fan_page_app/screens/Home.dart';
import 'package:fan_page_app/services/auth.dart';
import 'package:fan_page_app/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  FlutterNativeSplash.removeAfter(initialization);
  await Firebase.initializeApp();
  runApp(MyApp());
}

void initialization(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User1?>.value(
        value: AuthService().user,
        initialData: User1(uid: ""),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: Wrapper(),
        ));
  }
}
