import 'dart:async';
import 'dart:convert';

import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/PostDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'search_view.dart';

class EventPostPage extends StatefulWidget {
  @override
  _EventPostPageState createState() => new _EventPostPageState();
}

class _EventPostPageState extends State<EventPostPage> {

  EventDAO _eventDAO;
  Future<EventDTO> _eventDTO;
  Future<List<PostDTO>> _listData;

  @override
  void initState() {
    super.initState();
    _eventDAO = new EventDAO();
    _eventDTO = _eventDAO.getEvent(2);
    _listData = _eventDAO.getEventofGroup(2);
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
                        onFieldSubmitted: (String input){
                          if(input.trim().isNotEmpty)
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage(input) ));
                        }
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
            _eventUI(),
            _eventPostUI(),
          ],
        ),
      )),
    );
  }

  FutureBuilder _eventUI() {
    return FutureBuilder<EventDTO>(
        future: _eventDTO,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  child: Image.network(snapshot.data.imageUrl,
                      //height: 150,
                      fit: BoxFit.fill),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
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
                        FlatButton(
                          onPressed: (){

                          },
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(40)),
                          child: Text("Follow",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])
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

  FutureBuilder _eventPostUI() {
    return FutureBuilder<List<PostDTO>>(
        future: _listData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Thằng Nhân lại tắt máy nữa rồi :D");
          } else {
            return Column(
              children: <Widget>[
                for (PostDTO dto in snapshot.data)
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
                                    dto.postContent.toString().toUpperCase(),
                                    style: TextStyle(
                                        wordSpacing: 5.0,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
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
              ],
            );
          }
        });
  }
}
