import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchViewModel extends Model{

  static SearchViewModel _instance;

  static SearchViewModel getInstance() {
    if (_instance == null) {
      _instance = SearchViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  bool isLoading = false;
  List<EventDTO> list;
  bool error = false;



  SearchViewModel(){
  }

  Future<void> getEventResult(String text) async {
    try{
      error = false;
      isLoading = true;
      list = null;
      notifyListeners();
      EventDAO dao = new EventDAO();
      list = await dao.searchEvent(text);
      isLoading = false;
      notifyListeners();
    } on Exception{
      isLoading = false;
      error = true;
      notifyListeners();
    }


  }



}