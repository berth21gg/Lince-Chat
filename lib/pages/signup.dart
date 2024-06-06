import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lince_chat/pages/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? username;
  String? email;
  String? password;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Center(
          child: Form(
            key: key,
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Username'),
                  validator: ValidationBuilder().maxLength(10).build(),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                  validator: ValidationBuilder().email().maxLength(50).build(),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  validator:
                      ValidationBuilder().maxLength(16).minLength(6).build(),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (key.currentState?.validate() ?? false) {
                            try {
                              UserCredential userCred = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                      email: email!, password: password!);

                              if (userCred.user != null) {
                                var data = {
                                  'username': username,
                                  'email': email,
                                  'created_at': DateTime.now(),
                                };

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCred.user!.uid)
                                    .set(data);
                              }

                              if (mounted) {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ));
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: const Text('Sign up'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
