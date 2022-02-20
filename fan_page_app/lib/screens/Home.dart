import 'package:fan_page_app/models/constants.dart';
import 'package:fan_page_app/services/auth.dart';
import 'package:fan_page_app/services/database.dart';
import 'package:fan_page_app/services/helperfuncs.dart';
import 'package:fan_page_app/widgets/addMessage.dart';
import 'package:fan_page_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var loading = true;
  QuerySnapshot? snapshot;
  final AuthService _auth = AuthService();
  DatabaseServices databaseService = new DatabaseServices();
  late Stream<QuerySnapshot> messagesStream;
  TextEditingController messageController = new TextEditingController();
  void initState() {
    getInfo();
    dynamic value = databaseService.getMessagesFromFirestore();
    setState(() {
      messagesStream = value;
    });

    super.initState();
  }

  getInfo() async {
    await helperFunctions.getUserEmailSharedPreference().then((value) async {
      if (value != null || value?.length != 0) {
        databaseService.searchUserbyEmail(value!).then((val) => {
              snapshot = val,
              if (snapshot?.docs.length == 0)
                {
                  {getInfo()}
                }
              else
                {
                  loading = false,
                  setState(() {}),
                }
            });
      }
      // _auth.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Fan Page App"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                      child: GestureDetector(
                    child: Icon(Icons.logout),
                    onTap: () {
                      _auth.signOut();
                    },
                  )),
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: messagesStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.builder(
                          // reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // document
                            return Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      snapshot.data!.docs[index]['message'],
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          DateFormat('hh:mm a, dd, MMM').format(
                                              DateTime.parse(snapshot
                                                  .data!.docs[index]['time']
                                                  .toDate()
                                                  .toString())),
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            );
                          }),
                    );
                    // });
                  }),
                )),
              ],
            ),
            floatingActionButton: snapshot?.docs[0].data()['role'] == 'customer'
                ? null
                : AddButton(
                    messageController: messageController,
                    databaseService: databaseService),
          );
  }
}
