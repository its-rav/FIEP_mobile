import 'package:fiepapp/Model/Group.dart';
import 'package:fiepapp/Service/apiHelper.dart';

class GroupDAO{
  Future<Group> getGroup() async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.get("Group");
    return new Group.fromJson(json);
//    return new Group(
//      json['groupName'],
//      json['groupImgUrl'],
//    );
  }
}