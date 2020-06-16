import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';

class GroupDAO {
  Future<GroupDTO> getGroup(int groupID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("Groups/$groupID");
    return GroupDTO.fromJson(json, groupID);
  }

  Future<List<EventDTO>> getEventofGroup(int groupID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("Groups/$groupID/events");
    if (json['data'] != null) {
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJson(e, groupID)).toList();
    }
    return null;
  }
}
