import 'package:fiepapp/Model/Event.dart';
import 'package:fiepapp/Service/apiHelper.dart';

class EventDAO{
  Future<List<EventArticle>> getEvent() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("Events");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventArticle.fromJson(e)).toList().getRange(0, 4);
    }
//    return new EventArticle(
//        json['eventName'] as String,
//        json['timeOccur'],
//        json['eventImageUrl']
//    );
  return null;
  }
  Future<EventArticle> getAllEvent() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("Events");
    return new EventArticle.fromJson(json);
  }
  Future<EventArticle> get5Event() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("Events");
    return new EventArticle.fromJson(json);
  }
}