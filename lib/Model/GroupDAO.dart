import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';

class GroupDAO {
  Future<GroupDTO> getGroup(int groupID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("groups/$groupID");
    GroupDTO dto = GroupDTO.fromJson(json, groupID);
    print("Group: " + dto.toString());

    return dto;
  }

  Future<List<EventDTO>> getEventofGroup(int groupID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("groups/$groupID/events");
    if (json['data'] != null) {
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJson(e, groupID)).toList();
    }
    return null;
  }

  Future<List<GroupDTO>> get5Group() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("groups");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => GroupDTO.fromJsonAll(e)).toList().getRange(0, 4);
    }
    return null;
  }

  Future<List<GroupDTO>> getAllGroup() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("groups");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => GroupDTO.fromJsonAll(e)).toList();
    }
    return null;
  }
}
