import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyapar_bandhu/Screens/ownerNavigationScreen.dart';
import 'package:vyapar_bandhu/Screens/workerNavigationScreen.dart';
import 'package:vyapar_bandhu/modal/persons.dart';
import 'package:vyapar_bandhu/repo/loginAuth.dart';
import '../repo/usersRepository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//enum for userType
enum UserType { owner, worker }

class _LoginScreenState extends State<LoginScreen> {
  //static const String _title = 'Login With Google';

  //if Registering variable
  static bool isRegistering = true;
  static String headingTitle = 'Register';
  //Already Registered means want to login
  static String buttonTitle = 'Existing User? Login Here';
  //the Loginbutton title
  static String loginButtonTitle = 'Register';

  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String email = "";

  //value for radio button
  UserType userType = UserType.owner;

  //function for changing state accordingly Register/Login
  void decide() {
    setState(() {
      //reversing the value of isRegistering
      //according to them new titles will be chosen inside setState and ui will change
      if (isRegistering) {
        isRegistering = false;
      } else {
        isRegistering = true;
      }
      headingTitle = isRegistering ? 'Register' : 'Login';
      buttonTitle = isRegistering
          ? 'Existing User? Login Here'
          : 'New User? Register Here';
      loginButtonTitle = isRegistering ? 'Register' : 'Login';
    });
  }

  //the function that will be invoked when signing in(login button clicked)
  void signIn() async {
    //google sign in is pre-written in LoginAuth
    UserCredential user = await LoginAuth().signInWithGoogle();
    email = user.user?.email as String;

    String address = addressController.text;
    String age = ageController.text;
    String name = nameController.text;
    String type = userType.name;

    addressController.text = '';
    ageController.text = '';
    nameController.text = '';

    print(address);
    print(age);
    print(name);
    print(email);
    print(type);

    //function to add person according to their type owner/worker,only if they are registering first time
    if (isRegistering) {
      print('add user executed');
      UsersRepository().addUser(
        Persons(address, age, email, name,
            (userType.name == 'owner') ? true : false, ""),
      );
    }

    /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const WorkerNavigationScreen()));
*/
    //navigating to screen
    if (type == "owner") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const OwnerNavigationScreen()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const WorkerNavigationScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
              //title
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "$headingTitle With Google",
                  style: const TextStyle(color: Colors.blue, fontSize: 22),
                ),
              ),
              //to center the login button when not registering
              Visibility(
                visible: !isRegistering,
                child: const SizedBox(
                  height: 222,
                ),
              ),
              //wrapping name,address,age and radio with visible widget
              //to control their visibility accordingly
              //name
              Visibility(
                visible: isRegistering,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter Full Name',
                    ),
                  ),
                ),
              ),
              //address
              Visibility(
                visible: isRegistering,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Enter Address',
                    ),
                  ),
                ),
              ),
              //age
              Visibility(
                visible: isRegistering,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age',
                      hintText: 'Enter Age',
                    ),
                  ),
                ),
              ),
              //Radio Button for owner and worker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //radio button connects itself with an enum
                //and on changed is responsible for changing the global variable
                //group value is that global value holding the current selected option
                children: [
                  //owner
                  Row(
                    children: [
                      Radio(
                        //title: const Text('Owner'),
                        value: UserType.owner,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          setState(() {
                            userType = value!;
                          });
                        },
                      ),
                      const Text('Owner'),
                    ],
                  ),
                  //worker
                  Row(
                    children: [
                      Radio(
                        //title: const Text('Worker'),
                        value: UserType.worker,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          setState(() {
                            userType = value!;
                          });
                        },
                      ),
                      const Text('Worker'),
                    ],
                  ),
                ],
              ),
              //button for login,with container decoration
              Container(
                height: 50,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: signIn,
                  child: Text(
                    loginButtonTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 280,
              ),
              //button to choose Login/Register
              Center(
                child: TextButton(
                  onPressed: decide,
                  child: Text(
                    buttonTitle,
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
