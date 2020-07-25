import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';

import 'PostDTO.dart';

class EventDAO{

  Future<List<EventDTO>> getAllEvent() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("events");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJsonAll(e)).toList();
    }
    return null;
  }

  Future<List<EventDTO>> searchEvent(String text) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("events?query=$text");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJsonAll(e)).toList();
    }
    return null;
  }

  Future<EventDTO> getEvent(int eventID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("Events/$eventID");
    return EventDTO.fromJson(json, eventID);
  }

  Future<List<PostDTO>> getEventofGroup(int eventID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("Posts/$eventID");
    if (json['data'] != null) {
      var eventJson = json['data'] as List;
      return eventJson.map((e) => PostDTO.fromJson(e, eventID)).toList();
    }
    return null;
  }

}