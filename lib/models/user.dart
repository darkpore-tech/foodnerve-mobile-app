class User {
  final String uid;

  User({required this.uid});
}

class UserData {
  final String uid;
  final String myname;
  final String mymessage;
  final String myphone;

  UserData(
      {required this.uid,
      required this.myname,
      required this.mymessage,
      required this.myphone});
}
