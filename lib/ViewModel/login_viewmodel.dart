import 'package:fiepapp/API/api_exception.dart';
import 'package:fiepapp/Model/login_model.dart';
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

  void changeEventLogin() async {
   signOutGoogle();
    //await Future.delayed(const Duration(milliseconds: 100), (){});
    isLoading = true;
    text = null;
    notifyListeners();
    try {
      //String token = await validateAccount();
      String token = await signInWithGoogle();
      if (token != null) {
        text = "";
      } else {
        text = "An error has occurred. Please try app later!";
      }

    } on FetchDataException {
      text = "Error internet connection";
    } on BadRequestException {
      text = "Missing request field";
    } on UnauthorisedException {
      text = "Error user don't have authorization";

    } finally{
      isLoading = false;
      notifyListeners();

    }

    // text = await signInWithGoogle();
  }

}
