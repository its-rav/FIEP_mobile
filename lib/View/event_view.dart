import 'dart:async';
import 'dart:convert';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/Model/PostDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/group_view.dart';
import 'package:fiepapp/View/post_view.dart';
import 'package:fiepapp/ViewModel/follow_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'search_view.dart';

class EventPostPage extends StatefulWidget {
  int eventId;
  EventPostPage(this.eventId);
  @override
  _EventPostPageState createState() => new _EventPostPageState();
}

class _EventPostPageState extends State<EventPostPage> {

  EventDAO _eventDAO;
  Future<EventDTO> _eventDTO;
  Future<List<PostDTO>> _listData;
  GroupDAO _groupDAO;

  @override
  void initState() {
    super.initState();
    _eventDAO = new EventDAO();
    _eventDTO = _eventDAO.getEvent(widget.eventId);
    _listData = _eventDAO.getEventofGroup(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawerMenu(context),
        appBar: AppBar(
          title: _searchBar(),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Center(child: Text("Event Page", style: TextStyle(color: Colors.orange, fontSize: 23, fontWeight: FontWeight.bold),)),
                SizedBox(height: 10.0),
                _eventUI(),
                _eventPostUI(),
              ],
            ),
          ),
        ));
  }

  Widget _searchBar(){
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: Colors.grey,
      child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search, color: Colors.black),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: 'Search fo events',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onFieldSubmitted: (String input){
            if(input.trim().isNotEmpty)
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage(input) ));
          }
      ),
    );
  }

  FutureBuilder _eventUI() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if(snapshot.hasData){
          String user = snapshot.data.getString("USER");
          Map<String, dynamic> map = jsonDecode(user);
          return FutureBuilder<EventDTO>(
              future: _eventDTO,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                else{
                  String d1 = DateFormat("dd/MM/yyyy").format(DateTime.now());
                  String d2 = DateFormat("dd/MM/yyyy").format(snapshot.data.timeOccur);
                  String status = "End";
                  Color color = Colors.blue;
                  bool isFollow = false;
                  if(snapshot.data.timeOccur.isBefore(DateTime.now()) || snapshot.data.timeOccur.difference(DateTime.now()).inDays == 0){
                    if(d1 == d2){
                      status = "Current";
                      color = Colors.green;
                    }
                  }
                  else if(snapshot.data.timeOccur.isAfter(DateTime.now())){
                    isFollow = true;
                      status = "Coming";
                      color = Colors.red;

                  }
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 200,
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.notifications)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 40.0, bottom: 10),
                          child: Material(color: color,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(status, style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time),
                                  SizedBox(width: 5,),
                                  Text(DateFormat("dd/MM/yyyy hh:mm a").format(snapshot.data.timeOccur),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],

                              ),
                              ScopedModel(
                                model: new FollowViewModel(),
                                child: Column(
                                  children: <Widget>[
                                    isFollow ? followButton(map, widget.eventId) : Container(),
                                    followEventState(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.location_on),
                                  Text(" " + snapshot.data.location.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Text(snapshot.data.follower.toString() + " followers")
                            ],
                          ),
                        ),
                        groupCreate(snapshot.data.group),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.orange,
                                      style: BorderStyle.solid,
                                      width: 3.0))),
                          child: Text('Posts',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Timesroman',
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]);
                }

              });
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: CircularProgressIndicator()),
        );

      }
    );
  }

  Widget groupCreate(GroupDTO dto){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: <Widget>[
          Text("Created by: "),
          FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage(dto.id) ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                  child: Image(
                    image: NetworkImage(dto.imageUrl),
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(width: 5,),
                Text(dto.name, style: TextStyle(color: Colors.blue),)
              ],
            ),
          )
        ],
      ),
    );
      }

  Widget followButton(Map<String, dynamic> map, int id){
    List<int> listFollowGroup = new List<int>();
    if(map['follow event'] != null) {
      listFollowGroup = map['follow event'].cast<int>();
    }
    return ScopedModelDescendant<FollowViewModel>(
      builder: (BuildContext context, Widget child, FollowViewModel model) {
        model.getFollowEventStatus(listFollowGroup, id);
        if(model.isLoading){
          return Center(child: CircularProgressIndicator());
        }
        return FlatButton(
          color: Colors.orange,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor:
          Colors.black,
          child: Text(
            model.subEvent,
            style: TextStyle(
                fontSize: 18.0),
          ),
          onPressed: () async {
            AccountDTO dto = AccountDTO.fromJson(map['account']);
            if(dto != null){
              int result = await model.followEvent(dto.userId, id);
              if(result == 1){
                if(model.subEvent == "Following"){
                  listFollowGroup.add(id);
                } else listFollowGroup.removeWhere((element) => element == id);
                setState(() {
                  _eventDTO = _eventDAO.getEvent(widget.eventId);
                });
                SharedPreferences sp = await SharedPreferences.getInstance();
                map['follow event'] = listFollowGroup;
                sp.setString("USER", jsonEncode(map));
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
  FutureBuilder _eventPostUI() {
    return FutureBuilder<List<PostDTO>>(
        future: _listData,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Column(
              children: <Widget>[
                for (PostDTO dto in snapshot.data)
                  Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 16.0),
                    child: new Card(
                      elevation: 2.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(dto.id, widget.eventId) ));
                        },
                        child: new Column(
                          children: <Widget>[
                            new ClipRRect(
                              child: new Image.network(dto.imageUrl, fit: BoxFit.fill,),
                              borderRadius: BorderRadius.only(
                                  topLeft: new Radius.circular(16.0),
                                  topRight: new Radius.circular(16.0)),
                            ),
                            new Padding(
                              padding: new EdgeInsets.all(16.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(DateFormat("dd/MM/yyyy hh:mm a").format(dto.createDate)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      dto.postContent.toString(),
                                      style: TextStyle(
                                          wordSpacing: 5.0,
                                          fontSize: 20.0,
                                          fontFamily: 'san-serif'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Text("List is empty");
        });
  }

  Widget followEventState(){
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
