import 'package:fiepapp/API/api_exception.dart';
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
  
  Future<List<int>> getEventSubcription(String userId) async {
    try{
      ApiHelper api = new ApiHelper();
      dynamic json = await api.get("users/$userId/eventsubscriptions");
      if(json != null){
        List<int> list = json.cast<int>();
        return list;
      }

    } on BadRequestException{
      return null;
    }
  }

  Future<List<int>> getGroupSubcription(String userId) async{
    try{
      ApiHelper api = new ApiHelper();
      dynamic json = await api.get("users/$userId/groupsubscriptions");
      if(json != null){
        List<int> list = json.cast<int>();
        return list;
      }
    } on BadRequestException{
      return null;
    }
  }

  Future<int> updateAccount(AccountDTO dto) async {

    ApiHelper api = new ApiHelper();
    var json = await api.patch("users/" + dto.userId, dto.toJsonUpdate());
    if (json != null) return 1;
    return 0;
  }



}