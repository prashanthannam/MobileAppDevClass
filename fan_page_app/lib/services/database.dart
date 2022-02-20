import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DatabaseServices {
  Future uploadUserInfo(
      String fname, String lname, String email, String id) async {
    var uuid = Uuid();
    FirebaseFirestore.instance.collection('user').doc(id).set({
      'fname': fname,
      'lname': lname,
      'email': email,
      'userid': id,
      'time': DateTime.now(),
      'role': "customer"
    });
  }

  searchUserbyEmail(String email) {
    return FirebaseFirestore.instance
        .collection('user')
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  sendMessagetoFirestore(String message) {
    var time = DateTime.now();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(time.microsecondsSinceEpoch.toString())
        .set({
      'message': message,
      'time': time,
      'id': time.microsecondsSinceEpoch.toString()
    }).catchError((e) {
      print(e.toString());
    });
  }

  Stream<QuerySnapshot> getMessagesFromFirestore() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy("time", descending: true)
        .snapshots();
  }
}
