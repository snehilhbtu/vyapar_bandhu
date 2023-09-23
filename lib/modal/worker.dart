import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Worker {
  //9
  final String address;
  final int age;
  final String email;
  final String name;
  final String ownerEmail;

  const Worker(this.address, this.age, this.email, this.name, this.ownerEmail);

  Worker.fromJson(Map<String, dynamic> json)
      : address = json['address'] as String,
        age = json['age'] as int,
        email = json['email'] as String,
        name = json['name'] as String,
        ownerEmail = json['ownerEmail'] as String;

  Future<String> fetch() async {
    String email = "";
    await FirebaseFirestore.instance
        .collection('workers')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        email = documentSnapshot.get('ownerEmail');
        print('Document data: ${email}');
      } else {
        print('Document does not exist on the database');
      }
    });
    return email;
  }
}
