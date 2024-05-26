import 'dart:developer';
import 'dart:io';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? pickImage;

  _pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      File? croppedImage = await _cropImage(File(image.path));
      if (croppedImage != null) pickImage = File(croppedImage.path);
      if (mounted) {
        setState(() {});
      }
    }

    Navigator.pop(AppSettings.navigatorKey.currentContext!);
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
  }

  _handleImage() async {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
                title: const Text("Camera "),
              ),
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                title: const Text("Gallery "),
              ),
            ],
          );
        }));
  }

  _updateProfile() async {
    final ref = FirebaseStorage.instance.ref().child(DateTime.now().toString());
    await ref.putFile(pickImage!);
    final String imageUrl = await ref.getDownloadURL();
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({"image": imageUrl, "name": _nameController.text});
    Navigator.pop(AppSettings.navigatorKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                height: 0.3 * size.width,
                width: 0.3 * size.width,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(60)),
                child: InkWell(
                    onTap: () {
                      _handleImage();
                    },
                    child: pickImage != null
                        ? ClipOval(
                            child: Image.file(
                              File(pickImage!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.add)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value != null && value.length > 3) {
                          return null;
                        } else {
                          return "Enter valid name";
                        }
                      },
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: "Name"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        _updateProfile();
                      } else {
                        log("Nothing");
                      }
                    },
                    child: const Text("Save")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
