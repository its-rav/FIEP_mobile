import 'package:fiepapp/Model/Event.dart';
import 'package:fiepapp/Model/Group.dart';
import 'package:fiepapp/ViewModel/EventDAO.dart';
import 'package:fiepapp/ViewModel/GroupDAO.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  @override
  _HomeState createState() {
    // TODO: implement createState
    return new _HomeState();
  }
}

class _HomeState extends State<HomePage> {
//  Container MyArticles(String imageVal, String heading, String subHeading) {
//    return Container(
//        width: 250.0,
//        child: Card(
//          child: Wrap(
//            children: <Widget>[
//              Image.asset(
//                imageVal,
//                width: 250.0,
//                height: 250.0,
//              ),
//              ListTile(
//                title: Text(heading),
//                subtitle: Text(subHeading),
//              ),
//            ],
//          ),
//        ));
//  }

//  Container MyClub(String imageVal, String heading) {
//    return Container(
//        width: 250.0,
//        child: Card(
//          child: Wrap(
//            children: <Widget>[
//              Image.asset(
//                imageVal,
//                width: 250.0,
//                height: 250.0,
//              ),
//              ListTile(
//                title: Text(heading),
//              ),
//              Center(
//                child: RaisedButton(
//                  color: Colors.deepOrange,
//                  textColor: Colors.white,
//                  disabledColor: Colors.grey,
//                  disabledTextColor: Colors.black,
//                  elevation: 16,
//                  child: Text(
//                    'Follow Us',
//                    style: TextStyle(fontSize: 20.0),
//                  ),
//                  onPressed: () {},
//                  padding: EdgeInsets.all(8.0),
//                  splashColor: Colors.green,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(4))),
//                ),
//              )
//            ],
//          ),
//        ));
//  }
  Future<List<EventArticle>> list;
  EventDAO dao = null;
  Future<EventArticle> eventDTO;
  GroupDAO groupDAO = null;
  Future<List<Group>> listGroup;
  Future<Group> groupDTO;
  @override
  void initState(){
    super.initState();
    dao = new EventDAO();
//    eventDTO = dao.getEvent();
    list = dao.getEvent();
    groupDAO = new GroupDAO();
    groupDTO = groupDAO.getGroup();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(
              "FIEP",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15.0),
                new Row(
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
                          ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('INCOMING',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Timesroman',
                                    fontWeight: FontWeight.bold)),
                            Text('EVENT',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Timesroman',
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 210,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                color: Colors.black,
                                iconSize: 30,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/searchResult');
                                },
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 350,
                  child: FutureBuilder<List<EventArticle>>(
                    future: list,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data != null){
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for(EventArticle dto in snapshot.data)
                          Container(
                              width: 250.0,
                              child: Card(
                                child: Wrap(
                                  children: <Widget>[
                                    Image.network(
                                      dto.eventImageUrl,
                                      width: 250.0,
                                      height: 250.0,
                                    ),
                                    ListTile(
                                      title: Text(dto.eventName),
                                      subtitle: Text(dto.timeOccur),
                                    ),
                                  ],
                                ),
                              )
                          )
                            ],
                          );
                        }
                      }
                    }
                    )
                ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('UNIVERSITY',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Timesroman',
                                    fontWeight: FontWeight.bold)),
                            Text('CLUBS',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Timesroman',
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    height: 350,
                    child: FutureBuilder<List<Group>>(
                        future: listGroup,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data != null){
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  for(Group dtoGroup in snapshot.data)
                              Container(
                                  width: 250.0,
                                  child: Card(
                                    child: Wrap(
                                      children: <Widget>[
                                        Image.network(
                                          dtoGroup.groupImgUrl,
                                          width: 250.0,
                                          height: 250.0,
                                        ),
                                        ListTile(
                                          title: Text(dtoGroup.groupName),
                                        ),
                                        Center(
                                          child: RaisedButton(
                                            color: Colors.deepOrange,
                                            textColor: Colors.white,
                                            disabledColor: Colors.grey,
                                            disabledTextColor: Colors.black,
                                            elevation: 16,
                                            child: Text(
                                              'Follow Us',
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                            onPressed: () {},
                                            padding: EdgeInsets.all(8.0),
                                            splashColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(4))),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              )
                                ],
                              );
                            }
                          }
                        }
                    )
                ),
//                Container(
//                  margin: EdgeInsets.symmetric(vertical: 20.0),
//                  height: 380,
//                  child: ListView(
//                    scrollDirection: Axis.horizontal,
//                    children: <Widget>[
//                      MyClub("images/home/fcc.png", "Câu lạc bộ Cờ FCC"),
//                      MyClub("images/home/fev.jpg",
//                          "Câu lạc bộ tổ chức sự kiện FEV"),
//                      MyClub("images/home/cocsaigon.jpg",
//                          "Câu lạc bộ truyền thông Cóc Sài Gòn"),
//                      MyClub("images/home/siti.jpg",
//                          "Câu lạc bộ nhạc cụ truyền thống"),
//                      MyClub(
//                          "images/home/mec.jpg", "Câu lạc bộ truyền thông MEC"),
//                    ],
//                  ),
//                ),
              ],
            )),
          )),
    );
  }
}
