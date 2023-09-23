import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyapar_bandhu/modal/item.dart';

class ItemRepository {
  //refs for collections
  CollectionReference owners = FirebaseFirestore.instance.collection('owners');

  Future<void> addItem(Item item) {
    print('addItem invoked');
    //going inside owners->ownerDoc->items
    CollectionReference items = owners.doc(item.ownerEmail).collection('items');

    return items
        .doc(item.uid)
        .set({
          'currentQuantity': item.currentQuantity,
          'minQuantity': item.minQuantity,
          'name': item.name,
          'ownerEmail': item.ownerEmail,
          'pricePerUnit': item.price,
          'uid': item.uid,
        })
        .then((value) => print('item added'))
        .catchError((onError) => print('failed to add item'));
  }

  Future<CollectionReference> getItemsRef() async {
    String ownerEmail = "";
    await FirebaseFirestore.instance
        .collection('workers')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((snapshot) {
      ownerEmail = snapshot['ownerEmail'];
    });
    print('inside item repo getItemsRef $ownerEmail');

    CollectionReference itemsRef = await FirebaseFirestore.instance
        .collection('owners')
        .doc(ownerEmail)
        .collection('items');

    return itemsRef;
  }
}
