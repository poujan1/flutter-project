import 'package:chat_app/auth/login_screen.dart';
import 'package:chat_app/chat/chatdetailscreen.dart';
import 'package:chat_app/create_chat_room.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../profile_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(value: (false), onChanged: (_) {}),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout_rounded))
        ],
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const ProfileScreen()));
                },
                child: ClipOval(
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzXGXBA7Wfk1DUNgsSCZkw14oesWep0jXcmAomFx0&s",
                    height: 0.1 * size.width,
                    width: 0.1 * size.width,
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            const Center(child: Text("Chats")),
          ],
        ),
        // leading:
        //     IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        //  InkWell(
        //     onTap: () {
        //       Navigator.of(context).push(CupertinoPageRoute(
        //           builder: (context) => const ProfileScreen()));
        //     },
        //     child: ClipOval(
        //       child: Image.network(
        //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzXGXBA7Wfk1DUNgsSCZkw14oesWep0jXcmAomFx0&s",
        //         // height: 0.1 * size.width,
        //         // width: 0.1 * size.width,
        //       ),
        //     )),
      ),

      // body: ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       onTap: () {
      //         Navigator.push(
      //             context,
      //             CupertinoPageRoute(
      //                 builder: (context) => const ChatDetailScreen()));
      //       },
      //       title: const Text("Data"),
      //       leading: Padding(
      //         padding: const EdgeInsets.all(10.0),
      //         child: ClipOval(
      //             child: Image.network(
      //           "https://www.shutterstock.com/image-photo/surreal-concept-roll-world-dice-260nw-1356798002.jpg",
      //           height: 50,
      //           width: 30,
      //           fit: BoxFit.cover,
      //         )),
      //       ),
      //       trailing:
      //           IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      //       subtitle: const Text("pujan paneru"),
      //     );
      //   },
      // ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("uid", isNotEqualTo: user?.uid)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://www.shutterstock.com/image-photo/surreal-concept-roll-world-dice-260nw-1356798002.jpg",
                              scale: 1),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          data[index]["name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      String loggedInUserUid = user!.uid;
                      String otherUserUid = data[index]["name"];
                      String chatRoom =
                          createChatRoom(loggedInUserUid, otherUserUid);
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => ChatDetailScreen(
                                conversationTitle: data[index]["name"],
                                chatRoomId: chatRoom,
                              )));
                    },
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          }),
        ),
      ),
    );
  }
}
