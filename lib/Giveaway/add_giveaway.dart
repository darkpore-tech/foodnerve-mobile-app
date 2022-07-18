import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_nerve/Giveaway/giveaway_main.dart';
import 'package:food_nerve/models/database.dart';
import 'package:food_nerve/models/user.dart';
import 'package:food_nerve/shared/loading.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class AddGiveAway extends StatefulWidget {
  const AddGiveAway({super.key});
  @override
  State<AddGiveAway> createState() => _AddGiveAwayState();
}

class _AddGiveAwayState extends State<AddGiveAway> {
  late String _myName;
  late String _mymsg;
  final user = FirebaseAuth.instance.currentUser!;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spread Love'),
          centerTitle: true,
        ),
        body: StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData? userData = snapshot.data;
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.all(40),
                  child: Form(
                      key: formKey,
                      child: SizedBox(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Message',
                              ),
                              validator: (name) {
                                return name!.isEmpty
                                    ? 'Please enter your message'
                                    : null;
                              },
                              onSaved: (msg) {
                                _mymsg = msg!;
                              },
                            ),
                            const SizedBox(
                              height: 90,
                            ),
                            TextFormField(
                              initialValue: userData?.myname,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                              validator: (name) {
                                return name!.isEmpty
                                    ? 'Please enter your name'
                                    : null;
                              },
                              onSaved: (name) {
                                _myName = name!;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              onPressed: UploadStatusFreebie,
                              child: const Text(
                                'Add Giveaway',
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              } else {
                return const Loading();
              }
            }));
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> UploadStatusFreebie() async {
    if (validateAndSave()) {
      goToPage();
      saveToDatabase();
    }
  }

  void saveToDatabase() {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('dd MMM | HH:mm');
    var formatTime = DateFormat('HH:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    var data = {
      "name": _myName,
      "message": _mymsg,
      "date": date,
      "time": time,
    };
    reference.child("Freebies").push().set(data);
  }

  void goToPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GiveAway(),
      ),
    );
  }
}
