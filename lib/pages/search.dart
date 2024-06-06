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
                            leading: IconButton(
                              icon: const Icon(
                                Icons.chat,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                QuerySnapshot q = await FirebaseFirestore
                                    .instance
                                    .collection('chats')
                                    .where('users', arrayContains: [
                                  FirebaseAuth.instance.currentUser!.uid,
                                  doc.id,
                                ]).get();

                                if (q.docs.isEmpty) {
                                  // Create a new chat
                                  print('No doc');
                                  var data = {
                                    'users': [
                                      FirebaseAuth.instance.currentUser!.uid,
                                      doc.id,
                                    ],
                                    'recent_text': 'Hi',
                                  };

                                  await FirebaseFirestore.instance
                                      .collection('chats')
                                      .add(data);
                                } else {
                                  // start chat
                                  print('Yes doc');
                                }
                              },
                            ),
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
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
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
                                    child: const Text(
                                      'Follow',
                                      style: TextStyle(color: Colors.white),
                                    ),
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
