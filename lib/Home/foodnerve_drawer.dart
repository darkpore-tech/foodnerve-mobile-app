import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_nerve/models/database.dart';
import 'package:food_nerve/models/user.dart';
import 'package:food_nerve/shared/loading.dart';

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
                backgroundColor: Theme.of(context).primaryColorDark,
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
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
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            user.email!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.question_answer,
                        color: Colors.white,
                      ),
                      title: Text(
                        'FAQs',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.contact_phone,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Contact Support',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.white,
                    ),
                    ListTile(
                        leading: TextButton.icon(
                      onPressed: (() => FirebaseAuth.instance.signOut()),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                  ],
                ));
          } else {
            return const Loading();
          }
        });
  }
}
