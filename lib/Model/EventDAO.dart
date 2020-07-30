import 'package:fiepapp/API/api_exception.dart';
import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/EventWithPage.dart';

import 'PostDTO.dart';

class EventDAO{



  Future<List<EventDTO>> getUpcomingEvent() async{
    ApiHelper api = new ApiHelper();
    try{
      Map<String, dynamic> json = await api.get("events?isupcomming=true&pagesize=5&isdesc=false&sortby=0");
      if(json['data'] != null){
        var eventJson = json['data'] as List;
        return eventJson.map((e) => EventDTO.fromJson(e)).toList();
      }
      return null;
    } on BadRequestException{
      return new List<EventDTO>();
    }

  }

  Future<List<EventDTO>> getPopulatEvent() async{
    ApiHelper api = new ApiHelper();
    try{
      Map<String, dynamic> json = await api.get("events?isupcomming=true&pagesize=5&isdesc=true&sortby=1");
      if(json['data'] != null){
        var eventJson = json['data'] as List;
        return eventJson.map((e) => EventDTO.fromJson(e)).toList();
      }
      return null;
    } on BadRequestException{
      return new List<EventDTO>();
    }

  }

  Future<List<EventDTO>> searchEvent(String text) async{
    ApiHelper api = new ApiHelper();
    try{
      Map<String, dynamic> json = await api.get("events?query=$text");
      if(json['data'] != null){
        var eventJson = json['data'] as List;
        return eventJson.map((e) => EventDTO.fromJson(e)).toList();
      }
      return null;

    } on BadRequestException{
      return new List<EventDTO>();
    }
  }

  Future<EventWithPage> getEventBy(int type, bool isDecs) async{
    ApiHelper api = new ApiHelper();
    try{
      Map<String, dynamic> json = await api.get("events?pagesize=5&isDesc=$isDecs&sortby=$type");
      if(json != null){
        return EventWithPage.fromJson(json);
      }
      return null;
    } on BadRequestException{
      return new EventWithPage(null, 0, 0);
    }
  }

  Future<EventWithPage> addEventBy(int type, int page, bool isDecs) async{
    ApiHelper api = new ApiHelper();
    try{
      Map<String, dynamic> json = await api.get("events?pagesize=5&pagenumber=$page&isDesc=$isDecs&sortby=$type");
      if(json != null){
        return EventWithPage.fromJson(json);
      }
      return null;
    } on BadRequestException{
      return new EventWithPage(null, 0, 0);
    }
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