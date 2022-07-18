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
        title: const Text('Add Food Listing'),
        centerTitle: true,
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
        child: const Icon(Icons.add_a_photo),
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
                  // margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(right: 40, left: 40),
                  child: Column(
                    children: [
                      Image.file(
                        image!,
                        // fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
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
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Pick up location',
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
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: userData?.myphone,
                        decoration: const InputDecoration(
                          labelText: 'Phone number',
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
                      const SizedBox(
                        height: 30,
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
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: UploadStatusImage,
                        child: const Text(
                          'Add Post',
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
}
