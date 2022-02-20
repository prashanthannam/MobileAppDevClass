import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/models/constants.dart';
import 'package:fan_page_app/widgets/loading.dart';
import 'package:fan_page_app/services/auth.dart';
import 'package:fan_page_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/helperfuncs.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.toggleview}) : super(key: key);
  final Function toggleview;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  final AuthService _auth = AuthService();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  DatabaseServices databaseService = new DatabaseServices();

  final _formkey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String error = '';
  late QuerySnapshot usersnapshot;
  User? currentUser;

  findsignedCurUser(QuerySnapshot val) async {
    String curUser = val.docs[0].get('fname');
    String lname = val.docs[0].get('lname');

    helperFunctions.saveUserEmailSharedPreference(val.docs[0].get('email'));
    helperFunctions.saveUserFNameSharedPreference(curUser);
    helperFunctions.saveUserLNameSharedPreference(lname);

    helperFunctions.saveUserLoggedInSharedPreference(true);
    //  Constants.MyName=await helperFunctions.getUserNameSharedPreference();
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth?.idToken != null && googleAuth?.accessToken != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(bottom: 50, top: 100),
                color: Colors.deepPurple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // SizedBox(height: 20),
                            TextFormField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                  // icon: Icon(
                                  //   Icons.email,
                                  //   color: Colors.grey[600],
                                  // ),
                                  alignLabelWithHint: true,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  fillColor: Colors.deepPurple,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  )),
                              validator: (val) =>
                                  val == "" ? 'invalid email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025),
                            TextFormField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                  // icon: Icon(
                                  //   Icons.lock,
                                  //   color: Colors.grey[600],
                                  // ),
                                  alignLabelWithHint: true,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  fillColor: Colors.deepPurple,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  )),
                              validator: (val) => val!.length < 6
                                  ? 'password should be 6+ long'
                                  : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06),
                            RaisedButton(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              color: Colors.white,
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  usersnapshot = await databaseService
                                      .searchUserbyEmail(email);

                                  dynamic res = await _auth.signwithEMail(
                                      email, password);

                                  if (res == null) {
                                    setState(() {
                                      error = 'COULD NOT SIGN IN';
                                      loading = false;
                                    });
                                  } else {
                                    setState(() {
                                      Constants.MyFname =
                                          usersnapshot.docs[0].get('fname');
                                      Constants.MyLname =
                                          usersnapshot.docs[0].get('lname');
                                      Constants.role =
                                          usersnapshot.docs[0].get('role');
                                    });
                                    findsignedCurUser(usersnapshot);
                                  }
                                }
                              },
                              child: Text(
                                'Sign in',
                                style: (TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: new Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 15.0),
                                          child: Divider(
                                            color: Colors.white,
                                            height: 100,
                                          )),
                                    ),
                                    Text(
                                      "OR",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Expanded(
                                      child: new Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 15.0),
                                          child: Divider(
                                            color: Colors.white,
                                            height: 50,
                                          )),
                                    ),
                                  ]),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.05),
                              height: 46,
                              child: OutlineButton(
                                splashColor: Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  signInWithGoogle().then((user) async {
                                    if (user == null) {
                                      setState(() {
                                        loading = false;
                                      });
                                    } else {
                                      // authrizeApp(1);
                                      String fname =
                                          user.displayName.split(" ")[0];
                                      String lname =
                                          user.displayName.split(" ")[1];

                                      Constants.MyFname = fname;
                                      Constants.MyLname = lname;
                                      print(user.email);
                                      usersnapshot = await databaseService
                                          .searchUserbyEmail(user.email);
                                      if (usersnapshot.docs == null ||
                                          usersnapshot.docs.length == 0) {
                                        databaseService
                                            .uploadUserInfo(fname, lname,
                                                user.email, user.uid)
                                            .then((_) async {
                                          Constants.role = 'customer';
                                          usersnapshot = await databaseService
                                              .searchUserbyEmail(user.email)
                                              .then((res) => {
                                                    findsignedCurUser(res),
                                                  });
                                        });
                                      } else {
                                        Constants.role =
                                            usersnapshot.docs[0].data()['role'];
                                        findsignedCurUser(usersnapshot);
                                      }
                                      // if (usersnapshot.docs[0].get('email') !=
                                      //     null) {

                                      // }
                                    }
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                                highlightElevation: 0,
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                          image: AssetImage(
                                              "assets/google_logo.png"),
                                          height: 30.0),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Sign in with Google',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '* ' + error,
                              style: TextStyle(
                                color: Color.fromARGB(255, 252, 251, 251),
                              ),
                            ),
                            // SizedBox(height: 220,),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton.icon(
                        color: Colors.white,
                        onPressed: () {
                          widget.toggleview();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        label: Text(
                          'Dont have an account? Sign Up',
                          style: TextStyle(
                              fontSize: 18, color: Colors.indigo[700]),
                        ),
                        icon: Icon(
                          Icons.person,
                          color: Colors.indigo[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
