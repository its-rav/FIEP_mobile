import 'package:fiepapp/ViewModel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel(
     model: new LoginViewModel(),
      child: Scaffold(
        body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/login/school.jpg"),
            fit: BoxFit.cover,
          )),
          child: new Center(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 85, top: 35),
                child: Text("FPT Internal Event Platform",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
              ),
              _welcome(),
              _signInButton(),
              _textState()
            ],
          )),
        ),
      ),
    );
  }

  Widget _textState() {
    return ScopedModelDescendant<LoginViewModel>(

        builder: (BuildContext context, Widget child, LoginViewModel model) {
          
          if(model.isLoading){
            return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CircularProgressIndicator(),
                );
          }

          else if(model.text != null){
            if(model.text == ""){

              Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      ModalRoute.withName('/'));

            }
              return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(model.text,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                );
            

          }

            return
            Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
          );
          
        });

  }

  Container _welcome() {
    return Container(
      margin: const EdgeInsets.only(bottom: 200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GradientText(
            "FPT",
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepOrange, Colors.pink],
            ),
            style: TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          Text("IEP",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent))
        ],
      ),
    );
  }

  Widget _signInButton() {
    return ScopedModelDescendant<LoginViewModel>(
        builder: (BuildContext context, Widget child, LoginViewModel model){
          return FlatButton(
            color: Colors.white.withOpacity(0.8),
            focusColor: Colors.white.withOpacity(1.0),
            onPressed: (){
              model.changeEventLogin();
              //_viewModel.textStream.listen((event) { print("Text: $event");});
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Sign in with FPT",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Image(
                    image: AssetImage("images/login/google_logo.png"),
                    height: 35.0,
                    width: 35.0,
                  ),
                ],
              ),
            ),
          );
        }

    );
  }
}
