import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationTitle;
  final String chatRoomId;

  const ChatDetailScreen({
    super.key,
    required this.chatRoomId,
    required this.conversationTitle,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

bool _textFormFieldChanged = false;

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
                onTap: () {},
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
            Text(widget.conversationTitle),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),

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
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chats")
                      .doc(widget.chatRoomId)
                      .collection("users")
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final chats = snapshot.data?.docs ?? [];

                      return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          reverse: true,
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            {
                              bool isSentByMe =
                                  user!.uid == chats[index]["sent_by"];
                              return Row(
                                mainAxisAlignment: isSentByMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (!isSentByMe)
                                    ClipOval(
                                      child: Image.network(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzXGXBA7Wfk1DUNgsSCZkw14oesWep0jXcmAomFx0&s",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: isSentByMe
                                          ? Colors.blue
                                          : Colors.grey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(10),
                                        topRight: const Radius.circular(20),
                                        bottomLeft: isSentByMe
                                            ? const Radius.circular(20)
                                            : const Radius.circular(0),
                                        bottomRight: isSentByMe
                                            ? const Radius.circular(0)
                                            : const Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(chats[index]['message']),
                                  ),
                                  if (isSentByMe)
                                    ClipOval(
                                      child: Image.network(
                                        "https://images.unsplash.com/photo-1481349518771-20055b2a7b24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cmFuZG9tfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                ],
                              );
                            }
                          });
                    }
                    return const CircularProgressIndicator();
                  })),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {});
                        _textFormFieldChanged = true;
                      } else {
                        setState(() {});
                        _textFormFieldChanged = false;
                      }
                    },
                    textInputAction: TextInputAction.done,
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final auth = FirebaseAuth.instance.currentUser;
                    if (_messageController.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection("chats")
                          .doc(widget.chatRoomId)
                          .collection("users")
                          .add({
                        "message": _messageController.text,
                        "created_at": DateTime.now().toString(),
                        "chat_room_id": widget.chatRoomId,
                        "sent_by": auth?.uid,
                      });
                      _messageController.clear();
                    }
                    setState(() {});
                    _textFormFieldChanged = false;
                  },
                  icon: Icon(
                    _textFormFieldChanged ? Icons.send : Icons.thumb_up,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}
