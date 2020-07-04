import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/Model/PostDTO.dart';

class EventDAO{
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

  Future<List<EventDTO>> getAllEvent() async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("Events/");
    if (json['data'] != null) {
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJsonAll(e)).toList();
    }
    return null;
  }
}
