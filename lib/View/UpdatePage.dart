

import 'dart:convert';
import 'dart:io';

import 'package:fiepapp/Accessories/alert.dart';
import 'package:fiepapp/Model/AccountDAO.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';

class UpdateAccountPage extends StatefulWidget {

  AccountDTO dto;
  UpdateAccountPage(this.dto);
  @override
  _UpdateAccountState createState() {
    // TODO: implement createState
    return new _UpdateAccountState();
  }
}

class _UpdateAccountState extends State<UpdateAccountPage> {

  GlobalKey<FormState> _formkey = new GlobalKey();
  Image _userImage;
  String _imagePath;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: drawerMenu(context),
      body: userInfo(),
    );
  }


  @override
  void initState() {
    String defaultImage = "https://firebasestorage.googleapis.com/v0/b/fiep-e6602.appspot.com/o/users%2Fphoto-1-1590058860284452690018.jpg?alt=media&token=84430471-8893-4d2e-b233-638f702538a8";
    if(widget.dto.imageUrl != null){
      defaultImage = widget.dto.imageUrl;
    }
    _userImage = Image(
      image: NetworkImage(defaultImage),
      width: 100.0,
      height: 100.0,
      fit: BoxFit.cover,
    );
  }

  Widget userInfo() {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            userImage(),
            userItem("Name", widget.dto.name, 5, 250),
            userItem("Email", widget.dto.mail, 12, 150),
            userButton(),
          ],
        ),
      ),
    );
  }

  Widget userImage() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
          gradient: LinearGradient(
            colors: [Colors.cyan,
              Colors.indigo,],
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.white),
                shape: BoxShape.circle),
            child: ClipOval(child: _userImage),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            color: Colors.lightBlue,
            onPressed: () async {
              String path = await getImage();
              if (path == null) {
                print("No image selected");
              } else {
                setState(() {
                  _userImage = Image(
                    image: FileImage(File(path)),
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  );
                  _imagePath = path;
                });
              }
            },
            child: Text("Change image", style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }

  Widget userItem(String text, var value, int min, int max) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
      child: TextFormField(
        keyboardType: text.contains("Phone") ? TextInputType.number : TextInputType.multiline,
        inputFormatters: text.contains("Phone") ? <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly] : <TextInputFormatter>[],
        obscureText: text.contains("Password") ? true : false,
        initialValue: value.toString(),
        validator: (input) {
          if (input.trim().isEmpty || input.trim().length < min || input.trim().length > max)
            return text +
                " length must be between " +
                min.toString() + " and " + max.toString() +
                " characters";
          if(text == "Email"){
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern);
            if (!regex.hasMatch(input))
              return 'Enter Valid Email example" abc@gmail.com';
          }
        },
        onSaved: (newValue) {
          switch (text) {
            case "Name":
              widget.dto.name = newValue.trim();
              break;
            case "Email":
              widget.dto.mail = newValue.trim();
              break;
          }
          value = newValue;
        },
        decoration: InputDecoration(
          //fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          labelText: text,
        ),
      ),
    );
  }

  Widget userButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          textColor: Colors.white,
          color: Colors.blue,
          splashColor: Colors.lightBlue,
          child: Text("Save"),
          onPressed: () async {
            if (_formkey.currentState.validate()) {
              _formkey.currentState.save();
              int option = await getOption(context, "Apply changes to this user?");
              if (option == 1) {
                alertNoti(context, "Please wait", CircularProgressIndicator());
                String url = await uploadFirebase();
                if(url != null){
                  widget.dto.imageUrl = url;
                }
                AccountDAO dao = new AccountDAO();
                int result = await dao.updateAccount(widget.dto);
                if (result == 1) {
                  setState(() async {
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    String user = sp.getString("USER");
                    Map<String, dynamic> map = jsonDecode(user);
                    map['account'] = widget.dto.toJson();
                    sp.setString("USER", jsonEncode(map));
                  });
                  Navigator.pop(context);
                  alertNoti(context, "Update success", Icon(Icons.check_circle_outline, color: Colors.green,));
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                }
                else {
                  Navigator.pop(context);
                  alertNoti(context, "Update failed", Icon(Icons.cancel, color: Colors.red,));
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pop(context);
                }
              }
            }
          },
        ),
        SizedBox(
          width: 15,
        ),
        FlatButton(
          textColor: Colors.black,
          color: Colors.grey[300],
          splashColor: Colors.lightBlue,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }


  Future<String> getImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    return pickedFile.path;
  }



  Future<String> uploadFirebase() async{
    if(_imagePath != null){
      StorageReference storageReference = FirebaseStorage.instance.ref().child('Cast Image/${widget.dto.userId}' + ".jpg");
      StorageUploadTask uploadTask = storageReference.putFile(File(_imagePath));
      await uploadTask.onComplete;
      print('File Uploaded');
      String url = await storageReference.getDownloadURL();
      return url;
    }
    return null;
  }

}
