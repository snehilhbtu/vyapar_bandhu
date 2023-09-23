import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyapar_bandhu/Screens/sellItemScreen.dart';
import 'package:vyapar_bandhu/Screens/workerProfile.dart';
import 'package:vyapar_bandhu/modal/persons.dart';
import 'package:vyapar_bandhu/repo/itemRepository.dart';

class WorkerNavigationScreen extends StatelessWidget {
  const WorkerNavigationScreen({Key? key}) : super(key: key);
  static const String _title = 'Worker Screen';

  //funtion to show SellItemScreen and pass ref
  void showSellItem(var context) async {
    CollectionReference itemsRef = await ItemRepository().getItemsRef();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => SellItemScreen(itemsRef),
        ));
  }

  //function to get data->create person->show profile
  void showProfile(var context) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('workers')
        .doc(FirebaseAuth.instance.currentUser?.email!)
        .get();
    var data = snapshot.data();
    if (data != null) {
      //persons for workerProfile
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerProfile(Persons(
                data['address'],
                data['age'],
                data['email'],
                data['name'],
                false,
                data['ownerEmail'])),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title), backgroundColor: Colors.black),
      body: SafeArea(
        child: Column(
          children: [
            //vyapar Bandhu
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Vyapar Bandhu",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Sell Item
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 170,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      //icon and text inside row
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //icon for button
                          const Icon(
                            Icons.currency_rupee_rounded,
                            size: 100,
                            color: Colors.white,
                          ),
                          TextButton(
                            onPressed: () {
                              showSellItem(context);
                            },
                            child: const Text(
                              'Sell Item',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Profile button
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 170,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      //icon and text inside row
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //icon for button
                          const Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Colors.white,
                          ),
                          TextButton(
                            onPressed: () {
                              showProfile(context);
                            },
                            child: const Text(
                              'View Profile',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
