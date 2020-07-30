
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/Model/GroupWithPage.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupViewModel extends Model{

  static GroupViewModel _instance;

  static GroupViewModel getInstance() {
    if (_instance == null) {
      _instance = GroupViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  bool isLoading = false;
  List<GroupDTO> list;
  bool error = false;
  int currentPage;
  double totalPage;



  EventViewModel(){
  }

  Future<void> getGroupBy(bool isDesc) async {
    try{
      error = false;
      isLoading = true;
      list = null;
      notifyListeners();
      GroupDAO dao = new GroupDAO();
      GroupWithPage groupWithPage = await dao.getGroupBy(isDesc);
      currentPage = groupWithPage.currentPage;
      totalPage = groupWithPage.totalPage;
      list = groupWithPage.list;
    } on Exception{
      error = true;
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGroupBy(bool isDesc) async {
    try{
      if(currentPage < totalPage){
        error = false;
        isLoading = true;
        notifyListeners();
        GroupDAO dao = new GroupDAO();
        GroupWithPage groupWithPage = await dao.addGroupBy(++currentPage, isDesc);
        list.addAll(groupWithPage.list);
        currentPage = groupWithPage.currentPage;
        totalPage = groupWithPage.totalPage;
      }
    } on Exception{
      error = true;
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
  }


}