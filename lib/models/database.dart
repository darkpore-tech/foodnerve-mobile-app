import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_nerve/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference usersAccounts =
      FirebaseFirestore.instance.collection('users_accounts');

  Future<void> updateUserData(
      String myname, String mymessage, String myphone) async {
    return await usersAccounts.doc(uid).set({
      'myname': myname,
      'mymessage': mymessage,
      'myphone': myphone,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserData(
      myname: data['myname'],
      mymessage: data['mymessage'],
      myphone: data['myphone'],
      uid: uid,
    );
  }

  //get user doc stream
  Stream<UserData> get userData {
    return usersAccounts.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
