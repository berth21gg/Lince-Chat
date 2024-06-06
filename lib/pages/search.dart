import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search For a user'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Enter username"),
              onChanged: (value) {
                username = value;
                setState(() {});
              },
            ),
          ),
          if (username != null)
            if (username!.length > 3)
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: username)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.docs.isEmpty ?? false) {
                      return const Text('No user found');
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(doc['username']),
                            trailing: FutureBuilder<DocumentSnapshot>(
                              future: doc.reference
                                  .collection('followers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data?.exists ?? false) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        await doc.reference
                                            .collection('followers')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .delete();
                                        setState(() {});
                                      },
                                      child: const Text('Un Follow'),
                                    );
                                  }
                                  return ElevatedButton(
                                    onPressed: () async {
                                      await doc.reference
                                          .collection('followers')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set({
                                        'time': DateTime.now(),
                                      });
                                      setState(() {});
                                    },
                                    child: const Text('Follow'),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
        ],
      ),
    );
  }
}
