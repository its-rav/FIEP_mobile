

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication authentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: authentication.accessToken,
    idToken: authentication.idToken,
  );
  print("ID Token: " + authentication.idToken);

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return user.getIdToken().toString();
}

Future<bool> validateAccount() async {

  String idToken;

  signInWithGoogle().then((value) {
    idToken = value;
  });
  if(idToken != null){
    final response = await http.post("https://localhost:5001/api/user/login",
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
          "idToken": idToken,
    }),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> js = json.decode(response.body);
      int errorCode = js["errorCode"];
      if(errorCode == 0)
        return true;
    }
  }
  return false;
}



void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}