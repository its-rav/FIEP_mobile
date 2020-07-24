import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Services/google_signin_service.dart';
import 'package:fiepapp/Services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDAO{

  Future<AccountDTO> login() async {
    signOutGoogle();
    String token = await signInWithGoogle();
    if(token != null){
      ApiHelper api = new ApiHelper();
      PushNotificationService ps = new PushNotificationService();
      String fcmToken = await ps.getFcmToken();
      Map<String, String> map = new Map();
      map['idToken'] = token;
      map['fcmToken'] = fcmToken;
      dynamic json  = await api.post("auth/login", map);
      if(json['token'] != null){
        SharedPreferences sp = await SharedPreferences.getInstance();
        await sp.setString("TOKEN", json['token']);
      }
      if(json["userInfo"] != null){
        return AccountDTO.fromJson(json["userInfo"]);
      }
      return null;
    }


  }



}