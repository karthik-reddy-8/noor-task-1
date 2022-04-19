import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/preferences.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/preference_helper.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationViewModel extends ChangeNotifier {
  String photoLink = '';
  bool isLoading = false;
  bool imageLoaded = false;
  User? result = FirebaseAuth.instance.currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

  String image = '';
  final ImagePicker picker = ImagePicker();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  var secureText = true;
  final formKey = GlobalKey<FormState>();

  String basename(var image) {
    return image
        .substring(image.lastIndexOf("/"), image.lastIndexOf("."))
        .replaceAll("/", "");
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
      printLog(photoLink);
      showSnack(strings.profileUpdatedSuccessfully);
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

  void registerToFb(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    String fullName = firstName.text + ' ' + lastName.text;
    await writeIntoStorage(preference.name, fullName);
    await writeIntoStorage(preference.email, email.text);
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((result) {
      dbRef.child(result.user!.uid).set({
        "name": fullName,
        "email": email.text,
        "password": password.text,
        "phone": contactNumber.text,
        "photoUrl": photoLink
      }).then((res) {
        isLoading = false;
        showSnack(strings.registrationSuccessful);
        Navigator.pop(context);
        notifyListeners();
      });
    }).catchError((err) {
      isLoading = false;
      showSnack(err.message);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    contactNumber.dispose();
    super.dispose();
  }
}
