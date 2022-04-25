import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/constants.dart';
import 'package:chatapp/shared/loading.dart';
import 'package:chatapp/screens/Authenticate/helperfuncs.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Sign_in extends StatefulWidget {
  final Function toggleview;
  Sign_in({this.toggleview});
  @override
  _Sign_inState createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  DatabaseServices databaseService = new DatabaseServices();
  QuerySnapshot usersnapshot;

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  findsignedCurUser(QuerySnapshot val) async {
    String curUser = val.docs[0].get('name');
    helperFunctions.saveUserEmailSharedPreference(email);
    helperFunctions.saveUserNameSharedPreference(curUser);
    helperFunctions.saveUserLoggedInSharedPreference(true);
    //  Constants.MyName=await helperFunctions.getUserNameSharedPreference();
  }

  signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;
    if (googleAuth?.idToken != null && googleAuth?.accessToken != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user;
      return user;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.grey[900],
            //   title: Text('Sign In',),
            //   centerTitle: true,
            // ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(bottom: 50, top: 100),
                color: Colors.black87,
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
                            Container(
                                padding: EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Text(
                                  "ChatApp",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 124, 163, 163),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 50),
                                )
                                // child: Image.asset(
                                //   'assets/Logo.png',
                                //   width: 300,
                                //   fit: BoxFit.fill,
                                // ),
                                ),
                            SizedBox(height: 20),
                            TextFormField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.grey[600],
                                  ),
                                  alignLabelWithHint: true,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  fillColor: Colors.grey[900],
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
                                  val.isEmpty ? 'invalid email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.grey[600],
                                  ),
                                  alignLabelWithHint: true,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  fillColor: Colors.grey[900],
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
                              validator: (val) => val.length < 6
                                  ? 'password should be 6+ long'
                                  : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: 20),
                            RaisedButton(
                              elevation: 4,
                              color: Colors.white,
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  setState(() => loading = true);
                                  print('user');
                                  usersnapshot = await databaseService
                                      .searchUserbyEmail(email);
                                  setState(() {
                                    Constants.MyName =
                                        usersnapshot.docs[0].get('name');
                                  });
                                  dynamic res = await _auth.signwithEMail(
                                      email, password);

                                  if (res == null) {
                                    setState(() {
                                      error = 'COULD NOT SIGN IN';
                                      loading = false;
                                    });
                                  } else {
                                    Constants.MyProfPic =
                                        usersnapshot.docs[0].data()['profpic'];
                                    print(
                                        "user ${usersnapshot.docs[0].data()['name']}");
                                    Constants.MyName =
                                        usersnapshot.docs[0].data()['name'];
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
                                            height: 80,
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
                                      0.01),
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

                                      print(user.email);
                                      usersnapshot = await databaseService
                                          .searchUserbyEmail(user.email);
                                      if (usersnapshot.docs == null ||
                                          usersnapshot.docs.length == 0) {
                                        databaseService
                                            .uploadUserInfo(
                                                user.displayName, user.email)
                                            .then((_) async {
                                          usersnapshot = await databaseService
                                              .searchUserbyEmail(user.email)
                                              .then((res) => {
                                                    findsignedCurUser(res),
                                                  });
                                        });
                                      } else {
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
                              error,
                              style: TextStyle(
                                color: Colors.red,
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
