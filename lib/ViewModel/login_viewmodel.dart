import 'dart:async';

import 'package:fiepapp/API/api_exception.dart';
import 'package:fiepapp/Model/login_model.dart';


class LoginViewModel{


  StreamController<String> _textController = new StreamController<String>.broadcast();
  Sink get textSink => _textController;



  LoginViewModel(){
  }

//  Future<void> changeEvent() async {
//    String message = await getEventLogin();
//    textSink.add(message);
//  }

  Future<String> changeEventLogin() async {
    signOutGoogle();
    String text;
    try {
      String token = await validateAccount();
      print("Status code: $token");
      if (token != null) {
        text = "";
      }
      else {
        text = "An error has occurred. Please try app later!";
      }
    } on FetchDataException{
      text = "Error internet connection";
    }

    on BadRequestException{
      text = "Missing request field";
    }

    on UnauthorisedException{
      text = "Error user don't have authorization";
    }


    return text;
   // text = await signInWithGoogle();
  }

  Stream<String> get textStream => _textController.stream;

  dispose(){
    _textController.close();
  }
}