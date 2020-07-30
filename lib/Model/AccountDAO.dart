import 'package:fiepapp/API/api_exception.dart';
import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/EventSubcripstion.dart';
import 'package:fiepapp/Model/GroupSubcription.dart';
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
      print("Fcm Token: " + fcmToken);
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
        var eventJson = json as List;
        List<EventSubcription> listSub = eventJson.map((e) => EventSubcription.fromJson(e)).toList();
        List<int> list = new List<int>();
        for(EventSubcription event in listSub){
          list.add(event.eventId);
        }
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
        var eventJson = json as List;
        List<GroupSubcription> listSub = eventJson.map((e) => GroupSubcription.fromJson(e)).toList();
        List<int> list = new List<int>();
        for(GroupSubcription group in listSub){
          list.add(group.groupId);
        }
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

  Future<AccountDTO> getAccount(String id) async {
    ApiHelper api = new ApiHelper();
    var json = await api.get("users/" + id);
    if (json != null) return AccountDTO.fromJson(json);
    return null;
  }



}