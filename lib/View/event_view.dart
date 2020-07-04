import 'dart:async';
import 'dart:convert';

import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
//  final String uri = "https://171.235.181.73:8081/api/Events";
//  List data;

//  Future<String> getData() async {
//    var response = await http.get(
//        Uri.encodeFull(uri),
//        headers: {"Accept": "application/json"});
//
//    this.setState(() {
//      Map<String, dynamic> map = json.decode(response.body);
//      data = map['data'];
//    });
//
//    return "Success!";
//  }

  EventDAO _eventDAO;
  Future<EventDTO> _eventDTO;
  Future<List<EventDTO>> _listData;

  @override
  void initState() {
    super.initState();
    _eventDAO = new EventDAO();
    _eventDTO = _eventDAO.getEvent(2);
    _listData = _eventDAO.getAllEvent();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FIEP',
      home: Scaffold(
          body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
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
                    shadowColor: Colors.grey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                new IconButton(
                    icon: Icon(Icons.account_circle),
                    color: Colors.black,
                    iconSize: 30.0,
                    onPressed: () {}),
              ],
            ),
            SizedBox(height: 10.0),
            eventUI(),
          ],
        ),
      )),
    );
  }

  FutureBuilder eventUI() {
    return FutureBuilder<List<EventDTO>>(
        future: _listData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Thằng Nhân lại tắt máy nữa rồi :D");
          } else {
            return Column(
              children: <Widget>[
                for (EventDTO dto in snapshot.data)
                  Padding(
                    padding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 16.0),
                    child: new Card(
                      elevation: 2.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(16.0),
                      ),
                      child: new Column(
                        children: <Widget>[
                          new ClipRRect(
                            child: new Image.network(dto.imageUrl),
                            borderRadius: BorderRadius.only(
                                topLeft: new Radius.circular(16.0),
                                topRight: new Radius.circular(16.0)),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(16.0),
                            child: new Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    dto.name.toString().toUpperCase(),
                                    style: TextStyle(
                                        wordSpacing: 5.0,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'san-serif'),
                                  ),
                                ),
                                new SizedBox(height: 15.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    dto.location,
                                    style: TextStyle(
                                      wordSpacing: 3.0,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                new SizedBox(height: 5.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    dto.timeOccur,
                                    style: TextStyle(
                                        wordSpacing: 3.0, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        });
  }
}
