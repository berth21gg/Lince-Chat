import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lince_chat/pages/login.dart';
import 'package:lince_chat/pages/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Search(),
                ));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                    (route) => false);
              },
              title: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
