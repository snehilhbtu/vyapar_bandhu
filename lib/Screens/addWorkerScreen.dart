import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);
  static const String _title = 'Add Worker';

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  //stream of workers collection where owner email is empty
  Stream<QuerySnapshot> workerStream = FirebaseFirestore.instance
      .collection('workers')
      .where('ownerEmail', isEqualTo: "")
      .snapshots();

  //ref to worker collection
  CollectionReference workerRef =
      FirebaseFirestore.instance.collection('workers');

  //delete worker function -> it will update ownerEmail in worker as null
  void addWorker(String workerEmail) {
    workerRef
        .doc(workerEmail)
        .update({'ownerEmail': FirebaseAuth.instance.currentUser!.email!})
        .then((value) => print('worker $workerEmail removed  '))
        .catchError((onError) => print('failed to remove worker'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AddWorkerScreen._title),
        backgroundColor: Colors.black,
      ),
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
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
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
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
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
                                        const EdgeInsets.fromLTRB(10, 5, 0, 10),
                                    child: Text(
                                      '${snapshot.data!.docs[index].get('age')}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(
                              Icons.person_add_alt_outlined,
                              color: Colors.white,
                            ),
                            iconSize: 35,
                            onPressed: () => addWorker(
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
    );
  }
}
