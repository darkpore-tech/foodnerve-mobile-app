// import 'package:flutter/material.dart';
// import 'package:food_nerve/Merchandice/add_listing.dart';
// import 'package:food_nerve/Merchandice/posts.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:food_nerve/shared/loading.dart';

// import '../models/user_profile.dart';

// class Person extends StatefulWidget {
//   const Person({super.key});

//   @override
//   State<Person> createState() => _PersonState();
// }

// class _PersonState extends State<Person> {
//   List<Posts> postList = [];

//   @override
//   void initState() {
//     super.initState();
//     DatabaseReference ref = FirebaseDatabase.instance.ref().child('Posts');
//     ref.once().then((snap) {
//       dynamic keys = snap.snapshot.value;
//       dynamic KEYS = keys.keys;
//       dynamic data = snap.snapshot.value;
//       postList.clear();
//       for (var key in KEYS) {
//         Posts posts = Posts(
//           image: data[key]['image'],
//           description: data[key]['description'],
//           date: data[key]['date'],
//           time: data[key]['time'],
//           name: data[key]['name'],
//           phone: data[key]['phone'],
//           location: data[key]['location'],
//         );
//         postList.add(posts);
//       }
//       setState(() {
//         print('Length: ${postList.length}');
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: postList.isEmpty
//             ? const Loading()

//             : ListView.builder(
//                 itemCount: postList.length,
//                 itemBuilder: (context, index) {
//                   return PostsUI(
//                     image: postList[index].image,
//                     description: postList[index].description,
//                     date: postList[index].date,
//                     time: postList[index].time,
//                     name: postList[index].name,
//                     location: postList[index].location,
//                     phone: postList[index].phone,
//                   );
//                 },
//               ),
//       ),
//     );
//   }

//   // ignore: non_constant_identifier_names
//   Widget PostsUI(
//       {required String image,
//       required String description,
//       required String date,
//       required String time,
//       required String name,
//       required String location,
//       required String phone}) {
//     // final user = FirebaseAuth.instance.currentUser!;
//     return Card(
//       margin: const EdgeInsets.all(15),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               description,
//               style: Theme.of(context).textTheme.subtitle1,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Wrap(
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   children: [
//                     const Icon(Icons.location_on),
//                     Text(location),
//                   ],
//                 ),
//                 Wrap(
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   children: [
//                     const Icon(Icons.phone),
//                     Text(phone),
//                   ],
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
