import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyapar_bandhu/Screens/employeeManagementScreen.dart';
import 'package:vyapar_bandhu/Screens/ownerInventoryScreen.dart';
import 'package:vyapar_bandhu/Screens/ownerProfile.dart';

import '../modal/persons.dart';

class OwnerNavigationScreen extends StatelessWidget {
  const OwnerNavigationScreen({Key? key}) : super(key: key);
  static const String _title = 'Owner';

  //function to get data->create person->show profile
  void showProfile(var context) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('owners')
        .doc(FirebaseAuth.instance.currentUser?.email!)
        .get();
    var data = snapshot.data();
    if (data != null) {
      //persons for workerProfile
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerProfile(Persons(data['address'],
                data['age'], data['email'], data['name'], true, " ")),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title), backgroundColor: Colors.black),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Inventory
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
                          const SizedBox(
                            width: 20,
                          ),
                          //icon for button
                          const Icon(
                            Icons.list_alt_rounded,
                            size: 100,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OwnerInventoryScreen()));
                              },
                              child: const Text(
                                'Manage Inventory',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //employee management
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
                          const SizedBox(
                            width: 20,
                          ),
                          //icon for button
                          const Icon(
                            Icons.contact_page_outlined,
                            size: 100,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EmployeeManagementScreen()));
                              },
                              child: const Text(
                                'Manage Employees',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Profile
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
