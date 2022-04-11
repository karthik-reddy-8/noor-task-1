import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/preferences.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/App.dart';
import 'package:flutter_todo_app/utils/preference_helper.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationViewModel extends ChangeNotifier {
  String photoLink = '';
  bool isLoading = false;
  bool imageLoaded = false;
  User? result = FirebaseAuth.instance.currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");

  // late PickedFile _imageFile;
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

  Future<void> uploadFile(PickedFile file) async {
    isLoading = true;
    notifyListeners();
    if (file == null) {
      return null;
    }
    String imageName = basename(file.path);
    final destination = 'Profile-pic/$imageName';
    final ref = FirebaseStorage.instance.ref().child(destination);
    TaskSnapshot snapshot = await ref.putFile(File(file.path));
    var downloadUrl = (await snapshot.ref.getDownloadURL());
    if (snapshot.state == TaskState.success) {
      photoLink = downloadUrl.toString();
      await writeIntoStorage(preference.profilePic, downloadUrl.toString());
      print(photoLink);
      //showSnack("Profile Picture uploaded Successfully");
      isLoading = false;
      imageLoaded = true;
      notifyListeners();
    } else {
      //showSnack('Unable to upload the file');
    }
  }

  // Take image
  void takePhoto(ImageSource source) async {
    final pickerFile = await picker.getImage(
      source: source,
    );
    PickedFile? _imageFile;
    _imageFile = pickerFile!;
    image = _imageFile.toString();
    printLog(_imageFile);
    ChangeNotifier();
    uploadFile(_imageFile);
  }

  imageProfile(BuildContext context, String imageLink) {
    printLog('result : $imageLink');
    return Stack(
      children: [
        // CircleAvatar(
        //   radius: 70.0,
        //   backgroundColor: customColor.white,
        //   backgroundImage: imageLink == ''
        //       ? const AssetImage('assets/images/user.png')
        //       : (imageLink == imageLink
        //           ? NetworkImage(imageLink)
        //           : const AssetImage('assets/images/user.png')
        //               as ImageProvider),
        // ),
        CircleAvatar(
          radius: 70,
          backgroundColor: customColor.white,
          child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(70),
              child: Image.network(
                imageLink,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                      child: CircularProgressIndicator(
                          color: customColor.blueAccent));
                },
                alignment: Alignment.center,
                height: App.width * 0.34,
                width: App.width * 0.34,
                errorBuilder: (context, object, stackTrace) {
                  return const Icon(Icons.person);
                },
                fit: BoxFit.fill,
              ),
          ),
        ),
        Positioned(
            bottom: -1.0,
            right: -1.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet(context)),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.teal,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ))
      ],
    );
  }

  bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: App.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            strings.choosePhoto,
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              FlatButton.icon(
                icon: const Icon(
                  Icons.camera,
                  color: Colors.teal,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  takePhoto(ImageSource.camera);
                },
                label: Text(strings.camera),
              ),
              // ignore: deprecated_member_use
              FlatButton.icon(
                icon: const Icon(
                  Icons.image,
                  color: Colors.teal,
                ),
                onPressed: () {
                  //App.pop(App.ctx);
                  Navigator.pop(context);
                  takePhoto(ImageSource.gallery);
                },
                label: Text(strings.gallery),
              )
            ],
          )
        ],
      ),
    );
  }

// firebase connectivity
  void registerToFb(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    String fullName = firstName.text + ' ' + lastName.text;
    await writeIntoStorage(preference.userName, fullName);
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
        notifyListeners();
        print(strings.registrationSuccessful);
        // showSnack(Strings.registrationSuccessful);
        Navigator.pop(context);
      });
    }).catchError((err) {
      isLoading = false;
      notifyListeners();
      // showSnack(err.message);
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
