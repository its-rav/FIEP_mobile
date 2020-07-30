
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  if (!user.isAnonymous) {
    if (await user.getIdToken() != null) {
      String token = await user.getIdToken().then((value) => value.token);
      logLongString(token);
//      final FirebaseUser currentUser = await _auth.currentUser();
//      if(user.uid == currentUser.uid)
      return token;

    }
  }
  return null;
}

void logLongString(String s) {
  if (s == null || s.length <= 0) return;
  const int n = 1000;
  int startIndex = 0;
  int endIndex = n;
  print("ID Length: " + s.length.toString());
  while (startIndex < s.length) {
    if (endIndex > s.length) endIndex = s.length;
    print("Length: " + endIndex.toString());
    print(s.substring(startIndex, endIndex));
    startIndex += n;
    endIndex = startIndex + n;
  }
}

void signOutGoogle() async {

  await googleSignIn.signOut();

  print("User Sign Out");
}