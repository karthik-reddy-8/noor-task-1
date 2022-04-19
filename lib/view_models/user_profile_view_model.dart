import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/preferences.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/preference_helper.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/views/login_page.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileViewModel extends ChangeNotifier {
  String photoLink = '';
  bool isLoading = false;
  bool imageLoaded = false;
  User? result = FirebaseAuth.instance.currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

  String? image;
  String? profileImage;

  final ImagePicker picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String basename(var image) {
    return image
        .substring(image.lastIndexOf("/"), image.lastIndexOf("."))
        .replaceAll("/", "");
  }

  Future<void> initCall() async {
    profileImage = await readFromStorage(preference.photoUrl);
    nameController.text = await readFromStorage(preference.name);
    emailController.text = await readFromStorage(preference.email);
    contactNumberController.text = await readFromStorage(preference.phone);
    printLog('profileImage: $profileImage');
    notifyListeners();
  }

  Future<void> userSignOut(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut().then((res) async {
      await clearStorage();
      await App.pushAndRemoveUntil(const LoginPage());
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          err.message,
          style: TextStyle(color: customColor.white),
        ),
        backgroundColor: Colors.black,
      ));
    });
  }

  Future<void> uploadFile(XFile file, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    String imageName = basename(file.path);
    final destination = 'Profile-pic/$imageName';
    final ref = FirebaseStorage.instance.ref().child(destination);
    TaskSnapshot snapshot = await ref.putFile(File(file.path));
    var downloadUrl = (await snapshot.ref.getDownloadURL());
    if (snapshot.state == TaskState.success) {
      photoLink = downloadUrl.toString();
      await writeIntoStorage(preference.photoUrl, downloadUrl.toString());
      await updateDetails('photoUrl', photoLink);
      printLog(photoLink);
      showSnack(strings.profileUpdatedSuccessfully);
      profileImage = await readFromStorage(preference.photoUrl);
      isLoading = false;
      imageLoaded = true;
      notifyListeners();
    } else {
      showSnack(strings.imageUploadFailed);
    }
  }

  // Take image
  void takePhoto(ImageSource source, BuildContext context) async {
    XFile? pickerFile = await picker.pickImage(
      source: source,
    );
    XFile? _imageFile;
    _imageFile = pickerFile!;
    image = _imageFile.toString();
    printLog(_imageFile);
    ChangeNotifier();
    uploadFile(_imageFile, context);
  }

  Future<void> updateDetails(String key, String value) async {
    await deleteFromStorage(key);
    await writeIntoStorage(key, value);
    await dbRef.child(result?.uid ?? '').update({
      key: value,
    });
  }
}
