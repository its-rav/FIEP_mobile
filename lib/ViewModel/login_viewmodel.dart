
import 'package:fiepapp/API/api_exception.dart';
import 'package:fiepapp/Model/AccountDAO.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginViewModel extends Model {
  static LoginViewModel _instance;

  static LoginViewModel getInstance() {
    if (_instance == null) {
      _instance = LoginViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  bool isLoading = false;
  String text;

  LoginViewModel() {}

  Future<AccountDTO> changeEventLogin() async {
    isLoading = true;
    text = "";
    notifyListeners();
    try {

      AccountDAO dao = new AccountDAO();
      AccountDTO dto = await dao.login();
      return dto;

    } on FetchDataException {
      text = "Error internet connection";
    } on BadRequestException {
      text = "Missing request field";
    } on UnauthorisedException {
      text = "Error user don't have authorization";
    } on Exception{
      text = "An error has ocured. Please try app later!";
    }

    finally{
      isLoading = false;
      notifyListeners();
    }
  }


  Future<List<int>> getEventFollowStatus(String userId) async {
    try{
      AccountDAO dao = new AccountDAO();
      return dao.getEventSubcription(userId);
    } on BadRequestException{
      return null;
    }
  }

  Future<List<int>> getGroupFollowStatus(String userId) async {
    try{
      AccountDAO dao = new AccountDAO();
      return dao.getGroupSubcription(userId);
    } on BadRequestException{
      return null;
    }

  }

}
