import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginAuth {
  //google sign in function outside build
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    //only return after logging in, flow->auth->credential creation
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
/*
  Future<bool> isWorker(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('workers')
        .doc(email)
        .get() /*.catchError((error) => print('failed to get doc'))*/;

    if (snapshot.exists) {
      print('isworker');
      return true;
    } else {
      print('isworker false');
      return false;
    }
  }*/
}
