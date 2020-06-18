
import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Services/push_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final PushNotificationService _pushNotificationService=PushNotificationService();

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
      return token;
    }
  }
  return null;
}

Future<String> validateAccount() async {
  String idToken;

  await signInWithGoogle().then((value) {
    idToken = value;
  });
  if (idToken != null) {
//    print("API Url: "+apiUrl+"/auth/login");
//    final response = await http.post(
//      apiUrl+"/auth/login",
//      headers: <String, String>{
//        "Content-Type": "application/json; charset=UTF-8",
//      },
//      body: jsonEncode(<String, String>{
//        "idToken": idToken,
//      }),
//    );
//    return response.statusCode;
  ApiHelper api = new ApiHelper();
  Map<String, String> map = new Map();
  map['idToken'] = idToken;
  map['fcmToken'] = await _pushNotificationService.init();
  dynamic json  = api.post("Auth/Login", map);
  return json['jswToken'];
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