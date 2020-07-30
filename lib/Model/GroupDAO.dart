import 'package:fiepapp/API/api_exception.dart';
import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/Model/GroupWithPage.dart';

class GroupDAO {
  Future<GroupDTO> getGroup(int groupID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("groups/$groupID");
    GroupDTO dto = GroupDTO.fromJson(json);
    print("Group: " + dto.toString());
    return dto;
  }

  Future<List<GroupDTO>> getSubcripstionGroup(List<int> ids) async {
    ApiHelper api = new ApiHelper();
    List<GroupDTO> listGroup = new List<GroupDTO>();
    for(int i in ids){
      dynamic json = await api.get("groups/$i");
      GroupDTO dto = GroupDTO.fromJson(json);
      print("Group: " + dto.toString());
      listGroup.add(dto);
    }
    return listGroup;
  }



  Future<List<EventDTO>> getEventofGroup(int groupID) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("groups/$groupID/events");
    if (json['data'] != null) {
      var eventJson = json['data'] as List;
      return eventJson.map((e) => EventDTO.fromJson(e)).toList();
    }
    return null;
  }

  Future<List<GroupDTO>> get5Group() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("groups?pagesize=5&isDesc=true&sortby=0");
    if(json['data'] != null){
      var eventJson = json['data'] as List;
      return eventJson.map((e) => GroupDTO.fromJson(e)).toList();
    }
    return null;
  }

  Future<GroupWithPage> getGroupBy(bool isDecs) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("groups?pagesize=5&isDesc=$isDecs&sortby=0");
    if(json != null){
      return GroupWithPage.fromJson(json);
    }
    return null;
  }

  Future<GroupWithPage> addGroupBy(int page, bool isDecs) async{
    ApiHelper api = new ApiHelper();
    try{
      Map<String, dynamic> json = await api.get("groups?pagesize=5&pagenumber=$page&isDesc=$isDecs&sortby=0");
      if(json != null){
        return GroupWithPage.fromJson(json);
      }
      return null;
    } on BadRequestException{
      return new GroupWithPage(null, 0, 0);
    }
  }

 Future<int> followGroup(String userId, int id) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> map = {
      'groupId' : id,
      'userId' : userId,
      'subscriptionType' : 1
    };
    Map<String, dynamic> json = await api.post02("groupSubscriptions", map);
    if(json != null){
      return 1;
    }
    return 0;
  }

  Future<int> unfollowGroup(String userId, int id) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.delete("groupSubscriptions/$id/$userId");
    if(json != null){
      return 1;
    }
    return 0;
  }




}
