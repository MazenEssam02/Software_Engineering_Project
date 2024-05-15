import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenso/Models/User.dart';

class UserProvider with ChangeNotifier {
  AppUser? user;

  DocumentSnapshot? mydata;

  UserProvider() {
    fetchLogedUser();
  }

  Future<bool> fetchLogedUser() async {
    print("fetching userdata from server");
    bool code = false;
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        mydata = snapshot;
        user = AppUser.fromJson(data);
        code = true;
        notifyListeners();
      });
      notifyListeners();
    }
    return code;
  }

  void destroyUser() {
    user = null;
    notifyListeners();
  }
}
