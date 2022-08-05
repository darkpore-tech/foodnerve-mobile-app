import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_nerve/models/database.dart';
import 'package:food_nerve/models/user.dart';
import 'package:food_nerve/shared/loading.dart';

import 'about_us.dart';
import 'contact_support.dart';

class FoodNerveDrawer extends StatelessWidget {
  const FoodNerveDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Drawer(
                child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.greenAccent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          userData!.myname,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          user.email!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  color: Colors.white,
                ),
                ListTile(
                    leading: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUs(
                          initialUrl: '',
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.info_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'About Us',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )),
                ListTile(
                    leading: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Contact_Support()),
                    );
                  },
                  icon: Icon(
                    Icons.contact_phone_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Contact Support',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )),
                ListTile(
                    leading: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.question_answer_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'FAQs',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 0.6,
                  color: Colors.black,
                ),
                ListTile(
                    leading: TextButton.icon(
                  onPressed: (() => _showAlertDialog(context)),
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )),
              ],
            ));
          } else {
            return const Loading();
          }
        });
  }

  _showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Please Confirm"),
      content: const Text(
        "Do you really want to log out?",
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              FirebaseAuth.instance.signOut();
            },
            child: const Text('Yes'))
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
