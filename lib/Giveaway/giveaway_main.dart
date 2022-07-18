import 'package:flutter/material.dart';
import 'package:food_nerve/Giveaway/add_giveaway.dart';
import 'package:food_nerve/Giveaway/freebies.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_nerve/models/database.dart';
import 'package:food_nerve/shared/loading.dart';

class GiveAway extends StatefulWidget {
  const GiveAway({super.key});

  @override
  State<GiveAway> createState() => _GiveAwayState();
}

class _GiveAwayState extends State<GiveAway> {
  List<Freebies> freebieList = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Freebies');
    ref.once().then((snap) {
      dynamic keys = snap.snapshot.value;
      dynamic KEYS = keys.keys;
      dynamic data = snap.snapshot.value;
      freebieList.clear();
      for (var key in KEYS) {
        Freebies freebies = Freebies(
          message: data[key]['message'],
          date: data[key]['date'],
          time: data[key]['time'],
          name: data[key]['name'],
        );
        freebieList.add(freebies);
      }
      setState(() {
        print('Length: ${freebieList.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: freebieList.isEmpty
              ? const Loading()
              : ListView.builder(
                  itemCount: freebieList.length,
                  itemBuilder: (context, index) {
                    return FreebiesUI(
                      message: freebieList[index].message,
                      date: freebieList[index].date,
                      time: freebieList[index].time,
                      name: freebieList[index].name,
                    );
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Do Giveaway',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddGiveAway()));
            },
            child: const Icon(Icons.add)));
  }

  // ignore: non_constant_identifier_names
  Widget FreebiesUI({
    required String message,
    required String date,
    required String time,
    required String name,
  }) {
    final user = FirebaseAuth.instance.currentUser!;
    return Card(
      // elevation: 10,
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   userData.myname,
                // ),
                Text(name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left),
                Text(date, style: const TextStyle(fontSize: 12)),
                // Text(time, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
