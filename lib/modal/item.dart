import 'package:flutter/cupertino.dart';

class Item {
  //6
  final String currentQuantity;
  final String minQuantity;
  final String name;
  final String ownerEmail;
  final String price;
  final String uid;

  const Item(
      @required this.currentQuantity,
      @required this.minQuantity,
      @required this.name,
      @required this.ownerEmail,
      @required this.price,
      @required this.uid);

  Item.fromJson(Map<String, dynamic> json)
      : currentQuantity = json['currentQuantity'] as String,
        minQuantity = json['minQuantity'] as String,
        name = json['name'] as String,
        ownerEmail = json['ownerEmail'] as String,
        price = json['price'] as String,
        uid = json['uid'] as String;
}
