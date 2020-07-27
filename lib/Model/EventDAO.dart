import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';

import 'PostDTO.dart';

class EventDAO{

  Future<List<EventDTO>> getAllEvent() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("events");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJson(e)).toList();
    }
    return null;
  }

  Future<List<EventDTO>> getUpcomingEvent() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("events?isupcomming=true&isDesc=false&SortBy=0");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJson(e)).toList();
    }
    return null;
  }

  Future<List<EventDTO>> searchEvent(String text) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("events?query=$text");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJson(e)).toList();
    }
    return null;
  }

  Future<int> followEvent(String userId, int id) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> map = {
      'eventId' : id,
      'userId' : userId
    };
    Map<String, dynamic> json = await api.post02("eventSubscriptions", map);
    if(json != null){
    return 1;
    }
    return 0;
  }

  Future<int> unfollowEvent(String userId, int id) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.delete("eventSubscriptions/$id/$userId");
    if(json != null){
      return 1;
    }
    return 0;
  }

  Future<List<EventDTO>> getSubcripstionEvent(List<int> ids) async {
    ApiHelper api = new ApiHelper();
    List<EventDTO> listEvent = new List<EventDTO>();
    for(int i in ids){
      dynamic json = await api.get("events/$i");
      EventDTO dto = EventDTO.fromJson(json);
      print("Event: " + dto.toString());
      listEvent.add(dto);
    }
    return listEvent;
  }

  Future<EventDTO> getEvent(int eventID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("events/$eventID");
    return EventDTO.fromJson(json);
  }

  Future<List<PostDTO>> getEventofGroup(int eventID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("events/$eventID/posts");
    if (json['data'] != null) {
      var eventJson = json['data'] as List;
      return eventJson.map((e) => PostDTO.fromJson(e)).toList();
    }
    return null;
  }

}