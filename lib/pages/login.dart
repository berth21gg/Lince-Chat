import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lince_chat/pages/home.dart';
import 'package:lince_chat/pages/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email!, password: password!);

                          if (mounted) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const Home(),
                            ));
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'wrong-password') {
                            print('The password provided wrong.');
                          }
                          if (e.code == 'user-not-found') {
                            print('No user.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 12.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
                  },
                  child: const Text('Create an account'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
