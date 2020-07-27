import 'dart:convert';

import 'package:fiepapp/Model/AccountDAO.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/View/event_view.dart';
import 'package:fiepapp/View/group_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UpdatePage.dart';
import 'drawer.dart';


class ProfilePage extends StatefulWidget {
  AccountDTO dto;


  ProfilePage(this.dto);

  @override
  _ProfilePage createState() {
    // TODO: implement createState
    return new _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  Image _userImage;
  AccountDAO _accountDAO = new AccountDAO();
  Future<List<int>> listSubGroup;
  Future<List<int>> listSubEvent;

  String defaultImage = "https://firebasestorage.googleapis.com/v0/b/fiep-e6602.appspot.com/o/users%2Fphoto-1-1590058860284452690018.jpg?alt=media&token=84430471-8893-4d2e-b233-638f702538a8";

  @override
  void initState() {
    if(widget.dto.imageUrl != null){
      defaultImage = widget.dto.imageUrl;
    }
    _userImage = Image(
      image: NetworkImage(defaultImage),
      width: 100.0,
      height: 100.0,
      fit: BoxFit.cover,
    );
    listSubGroup = _accountDAO.getGroupSubcription(widget.dto.userId);
    listSubEvent = _accountDAO.getEventSubcription(widget.dto.userId);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawerMenu(context),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.cyan,
                    Colors.indigo,]
              )
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    userImage(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.dto.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.dto.userId,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Basic Info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.email, color: Colors.black),
                          SizedBox(width: 10,),
                          Text(widget.dto.mail,),
                        ],
                      ),
                    ),
                    updateButton(),
                    events(),
                    group()

//                    videos(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget updateButton(){
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          String user = snapshot.data.getString("USER");
          AccountDTO dto = AccountDTO.fromJson(jsonDecode(user)['account']);
          if(dto.userId == widget.dto.userId){
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 220),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.lightBlue,
                child: Row(
                  children: <Widget>[
                    Text("Edit Profile", style: TextStyle(color: Colors.white),),
                    SizedBox(width: 5,),
                    Icon(Icons.edit, color: Colors.white,)
                  ],
                ),
                onPressed: () async {
                  bool result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateAccountPage(widget.dto),));
                  if(result != null){
                    if(result){
                      SharedPreferences sp = await SharedPreferences.getInstance();
                      setState(() {
                        String user = sp.getString("USER");
                        Map<String, dynamic> map = jsonDecode(user);
                        widget.dto = AccountDTO.fromJson(map['account']);
                        if(widget.dto.imageUrl != null){
                          _userImage = Image(
                            image: NetworkImage(widget.dto.imageUrl),
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          );
                        }
                      });
                    }
                  }
                },
              ),
            );
          }
          return Container();
        }
        return Container();
      },
    );
  }

  Widget userImage() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.white),
          shape: BoxShape.circle),
      child: ClipOval(child: _userImage),
    );
  }

  Widget group(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Colors.deepOrange
              )
          )
      ),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Following Groups", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 214,
                child: groupDetail()
              )

            ],
          )
      ),
    );
  }

  Widget events(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Colors.deepOrange
              )
          )
      ),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Following Events", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 230,
                child: eventDetail()
              )

            ],
          )
      ),
    );
  }

  Widget groupDetail(){
    return FutureBuilder(
      future: listSubGroup,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if(snapshot.hasData){
          if(snapshot.data != null && snapshot.data.isNotEmpty){
            GroupDAO dao = new GroupDAO();
            return FutureBuilder(
              future: dao.getSubcripstionGroup(snapshot.data),
              builder: (BuildContext context, AsyncSnapshot<List<GroupDTO>> snapshot){
                if(snapshot.hasData){
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for(GroupDTO dto in snapshot.data)
                        Container(
                          width: 220,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 1,
                                    color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupPage(dto.id),));
                                setState(() {
                                  listSubGroup = _accountDAO.getGroupSubcription(widget.dto.userId);
                                });

                              },
                              child: Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(dto.imageUrl,
                                      width: 220.0,
                                      height: 150.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(dto.name),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          }
          return Text("List is empty");

        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("List is empty"),
          ),
        );
      },
    );
  }

  Widget eventDetail(){
    return FutureBuilder(
      future: listSubEvent,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if(snapshot.hasData){
          if(snapshot.data != null && snapshot.data.isNotEmpty){
            EventDAO dao = new EventDAO();
            return FutureBuilder(
              future: dao.getSubcripstionEvent(snapshot.data),
              builder: (BuildContext context, AsyncSnapshot<List<EventDTO>> snapshot){
                if(snapshot.hasData){
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for(EventDTO dto in snapshot.data)
                        Container(
                          width: 220,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 1,
                                    color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: InkWell(
                              onTap: () async {
                                print("event dto: " + dto.id.toString());
                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventPostPage(dto.id),));
                                setState(() {
                                  listSubEvent = _accountDAO.getEventSubcription(widget.dto.userId);
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(dto.imageUrl,
                                      width: 220.0,
                                      height: 150.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(dto.name),
                                    subtitle: Text(DateFormat("dd/MM/yyyy").format(dto.timeOccur)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          }
          return Text("List is empty");

        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("List is empty"),
          ),
        );
      },
    );
  }

}