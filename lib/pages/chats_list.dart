import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lince_chat/pages/chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Chats'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('chats')
            .where(
              'users',
              arrayContains: FirebaseAuth.instance.currentUser!.uid,
            )
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.docs.isEmpty ?? true) {
              return const Text('No chats!');
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                String otherUserId = (doc['users'] as List).firstWhere(
                    (uid) => uid != FirebaseAuth.instance.currentUser!.uid);

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, usersnapshot) {
                    if (usersnapshot.hasData) {
                      String username = usersnapshot.data!['username'];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(doc: doc),
                          ));
                        },
                        title: Text(username),
                        subtitle: Text(doc['recent_text']),
                        trailing: const Icon(Icons.arrow_forward),
                      );
                    } else {
                      return const ListTile(
                        title: Text('Loading...'),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
