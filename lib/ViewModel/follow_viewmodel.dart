
import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:scoped_model/scoped_model.dart';

class FollowViewModel extends Model{

  bool isLoading = false;
  String text;
  String subGroup = "Follow";
  String subEvent = "Follow";

  Future<int> followGroup(String accountId, int id) async {
    isLoading = true;
    text = "";
    notifyListeners();
    try{
      GroupDAO dao = new GroupDAO();
      if(subGroup == "Follow"){
        int result = await dao.followGroup(accountId, id);
        if(result > 0){
          subGroup = "Following";
          return 1;
        }
      }else{
        int result = await dao.unfollowGroup(accountId, id);
        if(result > 0){
          subGroup = "Follow";
          return 1;
        }
      }
      return 0;
    }on Exception catch(e, stacktrace){
     text = "An error has ocured";
     print(stacktrace);
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<int> followEvent(String accountId, int id) async {
    isLoading = true;
    text = "";
    notifyListeners();
    try{
      EventDAO dao = new EventDAO();
      if(subGroup == "Follow"){
        int result = await dao.followEvent(accountId, id);
        if(result > 0){
          subGroup = "Following";
          return 1;
        }
      }else{
        int result = await dao.unfollowEvent(accountId, id);
        if(result > 0){
          subGroup = "Follow";
          return 1;
        }
      }
      return 0;
    }on Exception catch(e, stacktrace){
      text = "An error has ocured";
      print(stacktrace);
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
  }

  void getFollowGroupStatus(List<int> listFollowGroup, int id ){
    if(listFollowGroup != null && listFollowGroup.isNotEmpty){
      if(listFollowGroup.contains(id)){
        print("Get Follow: " + id.toString());
        subGroup = "Following";
      }
    }
  }

  void getFollowEventStatus(List<int> listEvent, int id ){
    if(listEvent != null && listEvent.isNotEmpty){
      if(listEvent.contains(id)){
        print("Get Follow: " + id.toString());
        subEvent = "Following";
      }
    }
  }

}