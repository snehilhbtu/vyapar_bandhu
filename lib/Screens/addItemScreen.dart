import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyapar_bandhu/repo/itemRepository.dart';
import '../modal/item.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  static const String _title = 'Add Items';

  //controllers for text
  TextEditingController currentQuantityController = TextEditingController();
  TextEditingController minimumQuantityController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  //getting email of current user i.e. Owner
  String? ownerEmail = FirebaseAuth.instance.currentUser?.email;

  //this function will be  invoked when button pressed
  void addItem() async {
    String currentQuantity = currentQuantityController.text;
    String minimumQuantity = minimumQuantityController.text;
    String name = nameController.text;
    String price = priceController.text;
    String uid = name + ownerEmail!;

    //function calling to add item
    ItemRepository().addItem(
        Item(currentQuantity, minimumQuantity, name, ownerEmail!, price, uid));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            //name field
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter the name of item'),
              ),
            ),
            //price field
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    hintText: 'Enter Price'),
              ),
            ),
            //current quantity field
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: currentQuantityController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Current Quantity',
                    hintText: 'Enter Current Quantity'),
              ),
            ),
            //minimum quantity field
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: minimumQuantityController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Minimum Quantity',
                    hintText: 'Enter Minimum Quantity'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //Add Button
            Container(
              height: 50,
              width: 130,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                child: const Text(
                  'Add Item',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
                onPressed: addItem,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
