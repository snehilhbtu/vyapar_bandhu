import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vyapar_bandhu/Screens/loginScreen.dart';
import 'package:vyapar_bandhu/Screens/ownerNavigationScreen.dart';
import 'package:vyapar_bandhu/Screens/workerNavigationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String _title = "Vyapar Bandhu";
  String type = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecificField();
  }

  Future<String> getSpecificField() async {
    var field =
        "type"; // Replace with the name of the field you want to retrieve

    var snapshot = await FirebaseFirestore.instance
        .collection('commonUser')
        .doc(FirebaseAuth.instance.currentUser?.email!)
        .get();
    var data = snapshot.data();

    if (data != null && data.containsKey(field)) {
      print("type is ${data[field]}");
      setState(() {
        type = data[field];
      });
      return data[field];
    } else {
      return 'Field not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //on the time of opening the app , if not logged in the loginPage else accordingly
        home: (FirebaseAuth.instance.currentUser == null)
            ? const LoginScreen()
            : ((type == "owner")
                ? const OwnerNavigationScreen()
                : const WorkerNavigationScreen()));
  }
}
