import 'dart:convert';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/event_view.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:fiepapp/ViewModel/follow_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupPage extends StatefulWidget {
  int id;

  GroupPage(this.id);

  @override
  _GroupState createState() {
    // TODO: implement createState
    return new _GroupState();
  }

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
        appBar: AppBar(
          title: Text("Group"),
        ),
        body: SingleChildScrollView(
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
                  ]),
              SizedBox(height: 15.0),
              ui()
            ],
          ),
        ),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  FutureBuilder ui(){
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if(snapshot.hasData){
            String user = snapshot.data.getString("USER");
            Map<String, dynamic> map = jsonDecode(user);
            return Column(
              children: <Widget>[
                getGroupUI(map),
                getEventUI(map)
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          );
        }
    );
  }


  FutureBuilder getGroupUI(Map<String, dynamic> map) {
    return FutureBuilder<GroupDTO>(
        future: groupDTO,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
            );
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
                              followButton(map, widget.id),
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

  FutureBuilder getEventUI(Map<String, dynamic> map) {
    return FutureBuilder<List<EventDTO>>(
      future: list,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            String d1 = DateFormat("dd/MM/yyyy").format(DateTime.now());
            List<Widget> listWidget = new List<Widget>();
            for (EventDTO dto in snapshot.data){
              String d2 = DateFormat("dd/MM/yyyy").format(dto.timeOccur);
              String status = "End";
              Color color = Colors.blue;
              if(dto.timeOccur.isAfter(DateTime.now())){
                if(d1 == d2){
                  status = "Current";
                  color = Colors.green;
                }
                else{
                  status = "Coming";
                  color = Colors.red;
                }
              }
              listWidget.add(Container(
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
                    onTap: () async {
                      print("Event Id: " + dto.toString());
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventPostPage(dto.id)));
                      setState(() {
                        list = dao.getEventofGroup(widget.id);
                      });


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
                                        SizedBox(width: 5,),
                                        Text(DateFormat("dd/MM/yyyy hh:mm a").format(dto.timeOccur),
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Material(color: color,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(status, style: TextStyle(color: Colors.white),),
                                    ),

                                    )
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
              ));
            }
            return Column(
              children: listWidget,
            );
          }
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget followButton(Map<String, dynamic> map, int id){
    List<int> listFollowGroup = new List<int>();
    if(map['follow group'] != null){
      listFollowGroup = map['follow group'].cast<int>();
    }
    return ScopedModelDescendant<FollowViewModel>(
      builder: (BuildContext context, Widget child, FollowViewModel model) {
        model.getFollowGroupStatus(listFollowGroup, id);
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
            model.subGroup,
            style: TextStyle(
                fontSize: 18.0),
          ),
          onPressed: () async {
            AccountDTO dto = AccountDTO.fromJson(map['account']);
            if(dto != null){
              int result = await model.followGroup(dto.userId, id);
              if(result == 1){
                if(model.subGroup == "Following"){
                  listFollowGroup.add(id);
                } else listFollowGroup.removeWhere((element) => element == id);
                setState(() {
                  groupDTO = dao.getGroup(widget.id);
                });
                SharedPreferences sp = await SharedPreferences.getInstance();
                map['follow group'] = listFollowGroup;
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
