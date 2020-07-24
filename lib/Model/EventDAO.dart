import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';

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

}