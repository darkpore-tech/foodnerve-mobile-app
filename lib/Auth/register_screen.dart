// ignore_for_file: unnecessary_string_interpolations

import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_nerve/models/database.dart';
import 'package:food_nerve/Auth/login_page.dart';
import 'package:food_nerve/shared/loading.dart';

import '../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  var rememberValue = false;
  bool loading = false;
  final _enabledBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  );
  final _focusedBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 1.0),
  );
  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade700,
      body: Container(
        padding: const EdgeInsets.all(35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: firstNameController,
                            validator: (firstname) {
                              return firstname!.isEmpty
                                  ? 'First name is required'
                                  : null;
                            },
                            decoration: InputDecoration(
                                hintText: 'First name',
                                hintStyle: const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                border: _border,
                                enabledBorder: _enabledBorder,
                                focusedBorder: _focusedBorder),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: lastNameController,
                            decoration: InputDecoration(
                                hintText: 'Last name',
                                hintStyle: const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                border: _border,
                                enabledBorder: _enabledBorder,
                                focusedBorder: _focusedBorder),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: phoneNumberController,
                      validator: (phoneNumber) {
                        return phoneNumber!.isEmpty
                            ? 'Phone number is required'
                            : null;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          border: _border,
                          enabledBorder: _enabledBorder,
                          focusedBorder: _focusedBorder),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: emailController,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          border: _border,
                          enabledBorder: _enabledBorder,
                          focusedBorder: _focusedBorder),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          hintText: 'Enter your password (6+ char long)',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: _border,
                          enabledBorder: _enabledBorder,
                          focusedBorder: _focusedBorder),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          signUp();
                          sendToFirebase();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already registered?',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.toggleView();
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: Loading()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser!;
      await DatabaseService(uid: user.uid).updateUserData(
        '${firstNameController.text}',
        '${lastNameController.text}',
        '${phoneNumberController.text}',
      );
    } on FirebaseAuthException {
      loading = false;
      return ('Could not register with those credentials');
    }
    //The code below calls of dialog box after user signs in
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void sendToFirebase() {
    FirebaseFirestore.instance.collection('users_accounts').add({
      'first_name': '${firstNameController.text}',
      'last_name': '${lastNameController.text}',
      'phone_number': '${phoneNumberController.text}',
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    });
  }
}
