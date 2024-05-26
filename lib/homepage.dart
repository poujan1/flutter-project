import 'package:chat_app/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'auth/textf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddTextField()));
          // Navigator.pop(context);
          // FirebaseFirestore.instance.collection("Todos").add({"name": "name"});
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Chat App"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  trailing: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddTextField(
                                            documentId: data[index].id,
                                            title: data[index]["name"],
                                          )));
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                          onPressed: () async {
                            if (await confirm(
                              context,
                              title: const Text('Confirm'),
                              content: const Text('Would you like to remove?'),
                              textOK: const Text('Yes'),
                              textCancel: const Text('No'),
                            )) {
                              return FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(data[index].id)
                                  .delete();
                            }
                            {}

                            // showDialog(context: context, builder: (context)=>
                            // AlertDialog(title: Text("data"),
                            // content: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     ElevatedButton(onPressed: onPressed, child: child)
                            //   ],
                            // ),)
                            // )
                            // FirebaseFirestore.instance
                            //     .collection("chattings")
                            //     .doc(data[index].id)
                            //     .delete();
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  title: Text(data[index]["name"].toString()),
                );
              }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("created_by", isEqualTo: user?.uid)
            .snapshots(),
      ),
    );
  }
}
