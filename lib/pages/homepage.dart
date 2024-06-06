import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lince_chat/pages/login.dart';
import 'package:lince_chat/pages/search.dart';
import 'package:lince_chat/widgets/imagepost.dart';
import 'package:lince_chat/widgets/textpost.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController postext = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: postext,
                    decoration:
                        const InputDecoration(labelText: 'Post something'),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          var data = {
                            'time': DateTime.now(),
                            'type': 'text',
                            'content': postext.text,
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                          };

                          FirebaseFirestore.instance
                              .collection('posts')
                              .add(data);
                          postext.text = "";
                          setState(() {});
                        },
                        child: const Text(
                          'Post',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('timeline')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return Text('No posts for you');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .doc((snapshot.data?.docs[index].data()
                                  as Map)['post'])
                              .get(),
                          builder: (context, postsnapshot) {
                            if (postsnapshot.hasData) {
                              switch (postsnapshot.data!['type']) {
                                case 'text':
                                  return TextPost(
                                      text: postsnapshot.data!['content']);
                                case 'image':
                                  return ImagePost(
                                    text: postsnapshot.data!['content'],
                                    url: postsnapshot.data!['url'],
                                  );

                                default:
                                  return TextPost(
                                      text: postsnapshot.data!['content']);
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      },
                    );
                  }
                } else {
                  return LinearProgressIndicator();
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
