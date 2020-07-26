import 'dart:convert';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/event_home.dart';
import 'package:fiepapp/View/group_view.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:fiepapp/ViewModel/follow_viewmodel.dart';
import 'package:fiepapp/ViewModel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  Map<String, dynamic> map;


  HomePage(this.map);

  @override
  _HomeState createState() {
    // TODO: implement createState
    return new _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  Future<List<EventDTO>> list;
  EventDAO dao;
  Future<EventDTO> eventDTO;
  GroupDAO groupDAO;
  Future<List<GroupDTO>> listGroup;


  @override
  void initState() {
    super.initState();
    dao = new EventDAO();
    list = dao.getAllEvent();
    groupDAO = new GroupDAO();
    listGroup = groupDAO.getAllGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawerMenu(context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 15.0),
              searchBar(),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Colors.orange,
                              style: BorderStyle.solid,
                              width: 3.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('INCOMING EVENT',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Timesroman',
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: Colors.black,
                        iconSize: 30,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/searchResult');
                        },
                      )
                    ],
                  ),
                ),
              ),
              eventUI(),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Colors.orange,
                              style: BorderStyle.solid,
                              width: 3.0))),
                  child: Row(
                    children: <Widget>[
                      Text('UNIVERSITY CLUBS',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Timesroman',
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              groupUI()

            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar(){
    return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            icon: Icon(Icons.home),
            color: Colors.black,
            iconSize: 30,
            onPressed: () {},
          ),
          Flexible(
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(25.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon:
                    Icon(Icons.search, color: Colors.black),
                    contentPadding:
                    EdgeInsets.only(left: 15.0, top: 15.0),
                    hintText: 'Search for events',
                    hintStyle: TextStyle(color: Colors.grey)),
                onFieldSubmitted: (String input) {
                  if (input.trim().isNotEmpty)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchResultPage(input)));
                },
              ),
            ),
          ),
          new IconButton(
            icon: Icon(Icons.account_circle),
            color: Colors.black,
            iconSize: 30,
            onPressed: () {},
          ),
        ]);
  }

  Widget eventUI(){
    return FutureBuilder<List<EventDTO>>(
        future: list,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Container(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    for (EventDTO dto in snapshot.data)
                      Container(
                          margin: EdgeInsets.all(10),
                          width: 230.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 1,
                                    color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EventPage()));
                              },
                              child: Wrap(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image(
                                      image: NetworkImage(dto.imageUrl),
                                      width: 230.0,
                                      height: 200.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(dto.name),
                                    subtitle: Text(dto.timeOccur.replaceAll("T", " ")),
                                  ),
                                ],
                              ),
                            ),
                          ))
                  ],
                ),
              );
            }
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget groupUI(){
    return FutureBuilder<List<GroupDTO>>(
        future: listGroup,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List<int> listFollowGroup = new List<int>();
              if(widget.map['follow group'] != null){
                listFollowGroup = widget.map['follow group'].cast<int>();
              }

              return Container(
                height: 320,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    for (GroupDTO dtoGroup in snapshot.data)
                      Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(7, 7)
                                // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(10),
                          width: 230.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 1,
                                    color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GroupPage(dtoGroup.id, widget.map)));
                              },
                              child: Wrap(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(dtoGroup.imageUrl,
                                        height: 200, width: 230, fit: BoxFit.fill),
                                  ),
                                  ListTile(
                                    title: Text(dtoGroup.name),
                                    subtitle: ScopedModel<FollowViewModel>(
                                      model: new FollowViewModel(),
                                      child: Column(
                                        children: <Widget>[
                                          followButton(listFollowGroup, dtoGroup.id),
                                          followGroupState(),
                                        ],
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ))
                  ],
                ),
              );
            }
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget followButton(List<int> listFollowGroup, int id){
    return ScopedModelDescendant<FollowViewModel>(
      builder: (BuildContext context, Widget child, FollowViewModel model) {
        model.getFollowGroupStatus(listFollowGroup, id);
        if(model.isLoading){
          return Center(child: CircularProgressIndicator());
        }
        return FlatButton(
          color: Colors.deepOrange,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor:
          Colors.black,
          child: Text(
            model.subGroup,
            style: TextStyle(
                fontSize: 18.0),
          ),
          onPressed: () async {
            AccountDTO dto = AccountDTO.fromJson(widget.map['account']);
            if(dto != null){
              int result = await model.followGroup(dto.userId, id);
              if(result == 1){
                if(model.subGroup == "Following"){
                  listFollowGroup.add(id);
                } else listFollowGroup.removeWhere((element) => element == id);
                SharedPreferences sp = await SharedPreferences.getInstance();
                widget.map['follow group'] = listFollowGroup;
                sp.setString("USER", jsonEncode(widget.map));
                
              }
              
            }
          },
          padding:
          EdgeInsets.only(left: 8.0, right:  8.0),
          splashColor: Colors.green,
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(
                      4))),
        );
      },
    );
  }

  Widget followGroupState(){
    return ScopedModelDescendant<FollowViewModel>(
      builder: (BuildContext context, Widget child, FollowViewModel model) {
        if(model.text != null && model.text.isNotEmpty){
        return Center(child: Text(model.text, style: TextStyle(color: Colors.red),));
        }
        return Container();
      },
    );
  }
}
