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
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Spread Love',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.greenAccent,
        ),
        body: StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData? userData = snapshot.data;
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextFormField(
                                controller: messageController,
                                validator: (name) {
                                  return name!.isEmpty
                                      ? 'Please enter your message'
                                      : null;
                                },
                                onSaved: (msg) {
                                  _mymsg = msg!;
                                },
                                maxLines: 1,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 1.0),
                                  ),
                                  hintText: 'Message',
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 30, 20, 30),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextFormField(
                                initialValue: userData?.myname,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 1.0),
                                  ),
                                  hintText: 'Name',
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 15, 10, 15),
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
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              onPressed: UploadStatusFreebie,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.fromLTRB(100, 20, 100, 20),
                                backgroundColor: Colors.greenAccent,
                              ),
                              child: const Text(
                                'POST',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
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
      showAlertDialog(context);
      setState(() {
        messageController.clear();
      });
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

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Thank you!"),
      content: const Text(
        "You just saved a soul somewhere",
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'))
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
