
import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/EventWithPage.dart';
import 'package:scoped_model/scoped_model.dart';

class EventViewModel extends Model{

  static EventViewModel _instance;

  static EventViewModel getInstance() {
    if (_instance == null) {
      _instance = EventViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  bool isLoading = false;
  List<EventDTO> list;
  bool error = false;
  int currentPage;
  double totalPage;



  EventViewModel(){
  }

  Future<void> getEventBy(int type, bool isDecs) async {
    try{
      error = false;
      isLoading = true;
      list = null;
      notifyListeners();
      EventDAO dao = new EventDAO();
      EventWithPage eventWithPage = await dao.getEventBy(type, isDecs);
      currentPage = eventWithPage.currentPage;
      totalPage = eventWithPage.totalPage;
      list = eventWithPage.list;
    } on Exception{
      error = true;
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEventBy(int type, bool isDecs) async {
    try{
      if(currentPage < totalPage){
        error = false;
        isLoading = true;
        notifyListeners();
        EventDAO dao = new EventDAO();
        EventWithPage eventWithPage = await dao.addEventBy(type, ++currentPage, isDecs);
        list.addAll(eventWithPage.list);
        currentPage = eventWithPage.currentPage;
        totalPage = eventWithPage.totalPage;
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