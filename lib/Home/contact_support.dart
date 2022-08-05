import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Contact_Support extends StatefulWidget {
  const Contact_Support({Key? key}) : super(key: key);

  @override
  State<Contact_Support> createState() => _Contact_SupportState();
}

// ignore: camel_case_types
class _Contact_SupportState extends State<Contact_Support> {
  var messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback System',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Container(
            alignment: Alignment.center,
            width: screenSize.width,
            height: screenSize.height * 0.5,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 30, left: 30, right: 30, bottom: 20),
                      child: Text(
                        "What do you think can be improved on this app?",
                        style: TextStyle(fontSize: 25.0),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 35, right: 35, top: 15),
                      child: TextFormField(
                        controller: messageController,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter your message'
                              : null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 1.0),
                          ),
                          hintText: 'Your feedback',
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 35, right: 35, top: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submit();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void submit() {
    try {
      FirebaseFirestore.instance
          .collection('feedback')
          .add({'Message': messageController.text, 'Email': user.email});

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Message sent successfully!')),
      // );

      setState(() {
        messageController.clear();
      });

      showAlertDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Something went wrong, please try again.')),
      );
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Thank you!"),
      content: const Text(
        "We'll review it and make necessary adjustments",
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
