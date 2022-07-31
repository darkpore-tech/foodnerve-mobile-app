import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_nerve/Merchandice/merchandice.dart';
import 'package:food_nerve/models/database.dart';
import 'package:food_nerve/models/user.dart';
import 'package:food_nerve/shared/loading.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class AddListing extends StatefulWidget {
  const AddListing({super.key});

  @override
  State<AddListing> createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
  File? image;
  late String _myName;
  late String _myLocation;
  late String _myValue;
  late String _myPhone;
  String? url;
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  var descriptionController = TextEditingController();

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() {
      this.image = imageTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Food Listing',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            image != null
                ? enableUpload()
                : Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4,
                        left: MediaQuery.of(context).size.width * 0.2),
                    child: const Text(
                      'Select an image of the food',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pickImage(),
        child: const Icon(
          Icons.add_a_photo,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  enableUpload() {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.only(right: 40, left: 40),
                  child: Column(
                    children: [
                      Image.file(
                        image!,
                        // fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            hintText: 'Description',
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 30, 20, 30),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Description is required'
                                : null;
                          },
                          onSaved: (value) {
                            _myValue = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            hintText: 'Pick up location',
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          ),
                          validator: (location) {
                            return location!.isEmpty
                                ? 'Pick up location is required'
                                : null;
                          },
                          onSaved: (location) {
                            _myLocation = location!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          initialValue: userData?.myphone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            hintText: 'Phone Number',
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          ),
                          validator: (phone) {
                            return phone!.isEmpty
                                ? 'Please enter your phone number'
                                : null;
                          },
                          onSaved: (phone) {
                            _myPhone = phone!;
                          },
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
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            hintText: 'Name',
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
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
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: UploadStatusImage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(156, 20, 156, 20),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'POST',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            return const Loading();
          }
        });
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
  Future<void> UploadStatusImage() async {
    if (validateAndSave()) {
      final storageReference =
          FirebaseStorage.instance.ref().child('Post Images');
      var timeKey = DateTime.now();
      final uploadTask = storageReference.child("$timeKey.jpg").putFile(image!);
      var url = await (await uploadTask).ref.getDownloadURL();
      url = url.toString();
      goToPage();
      saveToDatabase(url);
      showAlertDialog(context);
      setState(() {
        descriptionController.clear();
      });
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('dd MMM | HH:mm');
    var formatTime = DateFormat('HH:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    var data = {
      "image": url,
      "name": _myName,
      "location": _myLocation,
      "description": _myValue,
      "date": date,
      "time": time,
      "phone": _myPhone
    };
    reference.child("Posts").push().set(data);
  }

  void goToPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Merchandice(),
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
              backgroundColor: Colors.orange[700],
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
