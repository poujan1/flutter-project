import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AddTextField extends StatefulWidget {
  final String? documentId;
  final String? title;
  const AddTextField({super.key, this.documentId, this.title});

  @override
  State<AddTextField> createState() => _AddTextFieldState();
}

class _AddTextFieldState extends State<AddTextField> {
  final TextEditingController _addText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _addText.text = widget.title!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.documentId == null ? "Add new todo" : "Update todo"),
          // leading: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       // Navigator.of(context).pushAndRemoveUntil(
          //       //     CupertinoPageRoute(builder: (context) => HomePage()),
          //       //     (route) => false);
          //     }),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _addText,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null;
                  } else {
                    return "name should be greater than 1 characters";
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (widget.documentId == null) {
                      await FirebaseFirestore.instance.collection("users").add(
                          {"name": _addText.text, "created_by": user!.uid});
                    } else {
                      await (FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.documentId))
                          .update(
                              {"name": _addText.text, "created_by": user!.uid});
                    }
                    Navigator.of(AppSettings.navigatorKey.currentContext!)
                        .pop();

                    // Navigator.of(AppSettings.navigatorKey.currentContext!)
                    //     .pushAndRemoveUntil(
                    //         CupertinoPageRoute(
                    //             builder: (context) => const HomePage()),
                    //         (route) => false);
                  }
                  // FirebaseFirestore.instance
                  //     .collection("chattings")
                  //     .add({"name": _addText.text});
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     CupertinoPageRoute(builder: (context) => HomePage()),
                  //     (route) => false);
                },
                child: Text(widget.documentId == null ? "Add" : "Update"),
              ),
            ],
          ),
        ));
  }
}
