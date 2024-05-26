// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({
//     super.key,
//   });

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   void firebaseGetInstances() {
//     FirebaseFirestore.instance.collection("users").get().then((value) => {
//           value.docs.forEach((result) {
//             print(value);
//             print(result.data());
//             // FirebaseFirestore.instance
//             //     .collection("users")
//             //     .doc(result.id)
//             //     .collection("users")
//             //     .get()
//             //     .then((value) => {
//             //           value.docs.forEach((element) => {print(element.data())})
//             //         });
//           })
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile Screen"),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           Center(
//             child: ClipOval(
//               child: Image.network(
//                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzXGXBA7Wfk1DUNgsSCZkw14oesWep0jXcmAomFx0&s",
//                 height: 0.3 * size.width,
//                 width: 0.3 * size.width,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             "profile picture",
//             style: Theme.of(context).textTheme.headline6,
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               firebaseGetInstances();
//               // Navigator.of(context).push(CupertinoPageRoute(
//               //     builder: (context) => const EditProfilePicture()));
//             },
//             child: const Text("yourName"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/edit_profile_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  // bool _isLoading = true;
  // var userData;
  // getCurrentUser() async {

  //   // userData = await FirebaseFirestore.instance
  //   //     .collection("users")
  //   //     .doc(user?.uid)
  //   //     .get();
  //   // _isLoading = false;
  //   // if (mounted) {
  //   //   setState(() {});
  //   // }
  // }

  // @override
  // void initState() {
  //   getCurrentUser();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile View"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return Builder(builder: (context) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // Center(
                    //   child: ClipOval(

                    //       child: Image(
                    //     image: userData['image'],
                    //     fit: BoxFit.cover,
                    //     height: 0.4 * size.width,
                    //     width: 0.4 * size.width,
                    //   )),
                    // ),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: userData["image"] ?? '',
                        height: 0.4 * size.width,
                        width: 0.4 * size.width,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return const Icon(
                            Icons.person_off,
                          );
                        },
                        placeholder: (context, url) {
                          return const Icon(Icons.person);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(userData['name']),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(userData['email']),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const Editprofile()));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.edit),
                            Text("Edit Profile")
                          ],
                        ))
                  ],
                );
              });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
