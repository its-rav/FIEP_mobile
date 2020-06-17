import 'dart:async';

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
    int code = await validateAccount();
    print("Status code: $code");
    if(code == 200){
      text = "";
    }
    else if(code == 401){
      text = "Error. User don't have authorized!";
    }
    else{
      text = "An error has occurred. Please try app later!";
    }

    return text;
   // text = await signInWithGoogle();
  }

  Stream<String> get textStream => _textController.stream;



  dispose(){
    _textController.close();
  }
}