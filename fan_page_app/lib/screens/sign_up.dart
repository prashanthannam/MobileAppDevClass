import 'package:fan_page_app/models/user.dart';
import 'package:fan_page_app/services/auth.dart';
import 'package:fan_page_app/services/database.dart';
import 'package:flutter/material.dart';
import '../widgets/loading.dart';
import '../services/helperfuncs.dart';
import '../models/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.toggleview}) : super(key: key);
  final Function toggleview;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final AuthService _auth = AuthService();
  DatabaseServices databaseService = new DatabaseServices();

  final _formkey = GlobalKey<FormState>();
  String fname = '';
  String lname = "";
  String email = '';
  String password = '';
  String error = '';

  findCurUser(String email, String fname, String lname) async {
    helperFunctions.saveUserEmailSharedPreference(email);
    helperFunctions.saveUserFNameSharedPreference(fname);
    helperFunctions.saveUserLNameSharedPreference(lname);

    helperFunctions.saveUserLoggedInSharedPreference(true);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 60, bottom: 50),
                color: Colors.deepPurple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.045),
                            TextFormField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  alignLabelWithHint: true,
                                  hintText: 'First Name',
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
                                  val == "" ? 'invalid Firat Name' : null,
                              onChanged: (val) {
                                setState(() => fname = val);
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025),
                            TextFormField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  alignLabelWithHint: true,
                                  hintText: 'Last Name',
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
                                  val == "" ? 'invalid Last Name' : null,
                              onChanged: (val) {
                                setState(() => lname = val);
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025),
                            TextFormField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  alignLabelWithHint: true,
                                  hintText: 'email',
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
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  alignLabelWithHint: true,
                                  hintText: 'password',
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
                                    MediaQuery.of(context).size.height * 0.025),
                            RaisedButton(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              // shape: BeveledRectangleBorder (
                              // side: BorderSide(color: Colors.indigo, width: 1.5)),
                              color: Colors.white,

                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  var us =
                                      await _auth.regwithEmail(email, password);
                                  if (us == null) {
                                    error = "account already exists";
                                    setState(() => loading = false);
                                  } else {
                                    User1 res = us;
                                    Constants.MyFname = fname;
                                    Constants.MyLname = lname;
                                    Constants.role = 'customer';
                                    findCurUser(email, fname, lname);
                                    if (res == null) {
                                      setState(() {
                                        error = 'please supply valid email';
                                        loading = false;
                                      });
                                    } else {
                                      Constants.MyFname = fname;
                                      Constants.MyLname = lname;
                                      Constants.role = 'customer';
                                      await databaseService.uploadUserInfo(
                                          fname, lname, email, res.uid);
                                    }
                                  }
                                }
                              },
                              child: Text(
                                'Sign Up',
                                style: (TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '* ' + error,
                              style: TextStyle(
                                color: Color.fromARGB(255, 253, 253, 253),
                              ),
                            ),
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
                          'Have an account? Sign In',
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
