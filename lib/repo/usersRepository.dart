import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:vyapar_bandhu/modal/persons.dart';

//users repo  will ask for person modal object and will upload that data
class UsersRepository {
  //refs for collections
  CollectionReference worker = FirebaseFirestore.instance.collection('workers');
  CollectionReference owner = FirebaseFirestore.instance.collection('owners');
  CollectionReference commonUser =
      FirebaseFirestore.instance.collection('commonUser');

  //for adding at the time of login according to type of person
  Future<void> addUser(Persons persons) {
    print('addUser invoked');
    //if user is owner
    if (persons.isOwner) {
      //also adding to common user
      commonUser.doc(persons.email).set({
        'email': persons.email,
        'type': 'owner',
      }).then((value) => print('owner added to common User'));
      return owner //using .doc and .set we are naming doc ourself,here doc_name->email
          .doc(persons.email)
          .set({
            'address': persons.address,
            'age': persons.age,
            'name': persons.name,
            'email': persons.email,
          })
          .then((value) => print('owner added'))
          .catchError((onError) => print('Failed to add owner'));
    } //is user is worker
    else {
      //also adding to common user
      commonUser.doc(persons.email).set({
        'email': persons.email,
        'type': 'worker',
      }).then((value) => print('worker added to common User'));
      return worker
          .doc(persons.email)
          .set({
            'address': persons.address,
            'age': persons.age,
            'name': persons.name,
            'email': persons.email,
            'ownerEmail': "",
          })
          .then((value) => print('worker added'))
          .catchError((onError) => print('Failed to add worker'));
    }
  }
}
