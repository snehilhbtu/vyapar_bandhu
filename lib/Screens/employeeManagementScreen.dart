import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyapar_bandhu/Screens/addItemScreen.dart';
import 'package:vyapar_bandhu/Screens/addWorkerScreen.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);
  static const String _title = 'Employee Management';

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  //stream of workers collection where owner email is same as current user
  Stream<QuerySnapshot> workerStream = FirebaseFirestore.instance
      .collection('workers')
      .where('ownerEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  //ref to worker collection
  CollectionReference workerRef =
      FirebaseFirestore.instance.collection('workers');

  //delete worker function -> it will update ownerEmail in worker as null
  void removeWorker(String workerEmail) {
    workerRef
        .doc(workerEmail)
        .update({'ownerEmail': ""})
        .then((value) => print('worker $workerEmail removed  '))
        .catchError((onError) => print('failed to remove worker'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(EmployeeManagementScreen._title),
          backgroundColor: Colors.black),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: workerStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      //we have used flex in the column and icon as well to allot 3:1 space
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name of worker
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Text(
                                  snapshot.data!.docs[index].get('name'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              //email of worker
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: Text(
                                  '${snapshot.data!.docs[index].get('email')}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              //age
                              Row(
                                children: [
                                  //heading age
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text(
                                      'Age :',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  //age of worker
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 7, 0, 0),
                                    child: Text(
                                      '${snapshot.data!.docs[index].get('age')}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //address of worker
                              //age
                              Row(
                                children: [
                                  //heading age
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                                    child: Text(
                                      'Address :',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  //age of worker
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 10),
                                    child: Text(
                                      '${snapshot.data!.docs[index].get('address')}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(
                              Icons.person_remove_alt_1_outlined,
                              color: Colors.white,
                            ),
                            iconSize: 35,
                            onPressed: () => removeWorker(
                                snapshot.data!.docs[index].get('email')),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      //floating action button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              //the screen which will show unhired workers(where ownerEmail is empty)
              MaterialPageRoute(builder: (context) => const AddWorkerScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
/*ListView.builder(
          itemCount: EmployeeManagementScreen.names.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  //we have used flex in the column and icon as well to allot 3:1 space
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //name of worker
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                            child: Text(
                              EmployeeManagementScreen.names[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          //age of worker
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'age :${EmployeeManagementScreen.age[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        iconSize: 22,
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),*/
