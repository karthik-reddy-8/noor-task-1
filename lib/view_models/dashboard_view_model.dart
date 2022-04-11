import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/services/model/response/user_data_response_model.dart';
import 'package:flutter_todo_app/utils/utilities.dart';

class DashboardViewModel extends ChangeNotifier{
 bool isLoading = false;
 final DatabaseReference dbRefer = FirebaseDatabase.instance.ref();
 final FirebaseAuth auth = FirebaseAuth.instance;
 List<UserDataResponseModel> userList = [];

 Future<void> initCall() async {
   await getUserData();
 }

 Future<dynamic> getUserData() async{
  printLog('User Id:- ${auth.currentUser?.uid}');
  dbRefer.child('Users').orderByKey()
      .equalTo(auth.currentUser?.uid)
      .once()
      .then((event) {
   dynamic response = event.snapshot.value;
   printLog('User data:- $response');
   userList.clear();
   response.forEach((key, value){
    UserDataResponseModel responseModel = UserDataResponseModel(
     photoUrl: value['photoUrl'],
     phone: value['phone'],
     password: value['password'],
     email: value['email'],
     name: value['name']
    );
    userList.add(responseModel);
   });
   notifyListeners();
  }).catchError((onError) {
   printLog(onError);
    showSnack(message: onError);
  });
  printLog(userList.length);
 }
}