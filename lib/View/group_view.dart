import 'dart:convert';
import 'dart:math';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/event_home.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:fiepapp/ViewModel/follow_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupPage extends StatefulWidget {
  final int id;
  Map<String, dynamic> map;

  @override
  _GroupState createState() {
    // TODO: implement createState
    return new _GroupState();
  }

  GroupPage(this.id, this.map);
}

class _GroupState extends State<GroupPage> {
  GroupDAO dao;
  Future<GroupDTO> groupDTO;
  Future<List<EventDTO>> list;

  _GroupState();

  @override
  void initState() {
    super.initState();
    dao = new GroupDAO();
    groupDTO = dao.getGroup(widget.id);
    list = dao.getEventofGroup(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      endDrawer: drawerMenu(context),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Row(
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
                              }),
                        ),
                      ),
                      new IconButton(
                        icon: Icon(Icons.account_circle),
                        color: Colors.black,
                        iconSize: 30,
                        onPressed: () {},
                      ),
                    ]),
                SizedBox(height: 15.0),
                getGroupUI(),
                getEventUI(),
              ],
            ),
          )),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }


  FutureBuilder getGroupUI() {
    return FutureBuilder<GroupDTO>(
        future: groupDTO,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<int> listFollowGroup = new List<int>();
          if(widget.map['follow group'] != null){
            listFollowGroup = widget.map['follow group'].cast<int>();
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 230,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(snapshot.data.imageUrl,
                      //height: 150,
                      fit: BoxFit.fill),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          snapshot.data.name,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ScopedModel(
                          model: new FollowViewModel(),
                          child: Column(
                            children: <Widget>[
                              followButton(listFollowGroup, widget.id),
                              followGroupState(),
                            ],
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    snapshot.data.follower.toString() + " Followers",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Colors.orange,
                              style: BorderStyle.solid,
                              width: 3.0))),
                  child: Text('EVENTS',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Timesroman',
                          fontWeight: FontWeight.bold)),
                ),
              ]);
        });
  }

  FutureBuilder getEventUI() {
    return FutureBuilder<List<EventDTO>>(
      future: list,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List<int> listFollowEvent = new List<int>();
            if(widget.map['follow event'] != null){
              listFollowEvent = widget.map['follow event'].cast<int>();
            }
            return Column(
              children: <Widget>[
                for (EventDTO dto in snapshot.data)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: Offset(7, 7)
                            // changes position of shadow
                            ),
                      ],
                    ),
                    margin: EdgeInsets.all(10),
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
                                  builder: (context) => EventPage()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(dto.imageUrl,
                                  height: 230, width: 250, fit: BoxFit.fill),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      dto.name,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'san-serif'),
                                    ),
                                  ]),
                            ),
                            Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.access_time),
                                            Text(" " + dto.timeOccur
                                                .toString()
                                                .replaceAll("T", " ").substring(0, 16),
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],

                                        ),
                                        followButtonEvent(listFollowEvent, dto.id)

                                      ],

                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on),
                                            Text(" " + dto.location,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(dto.follower.toString() + " followers")
                                      ],

                                    ),
                                  ),

                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        }
        return Container();
      },
    );
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

  Widget followButtonEvent(List<int> listFollowEvent, int id){
    return ScopedModel(
      model: new FollowViewModel(),
      child: ScopedModelDescendant<FollowViewModel>(
        builder: (BuildContext context, Widget child, FollowViewModel model) {
          model.getFollowGroupStatus(listFollowEvent, id);
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
                int result = await model.followEvent(dto.userId, id);
                if(result == 1){
                  if(model.subGroup == "Following"){
                    listFollowEvent.add(id);
                  } else listFollowEvent.removeWhere((element) => element == id);
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  widget.map['follow event'] = listFollowEvent;
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
      ),
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
