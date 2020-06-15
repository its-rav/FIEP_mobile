import 'dart:html';

import 'package:dio/dio.dart';
import 'package:fiepapp/Model/Event.dart';
import 'package:flutter/material.dart';


class SearchResultPage extends StatefulWidget{
  @override
  _SearchResultPage createState() {
    // TODO: implement createState
    return new _SearchResultPage();
  }

}
class _SearchResultPage extends State<SearchResultPage> {
  final dio = new Dio(); // for http requests
  Future<List<EventArticle>> list;

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
                                Text('SEARCH',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Timesroman',
                                        fontWeight: FontWeight.bold)),
                                Text('RESULT',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Timesroman',
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      height: 400,
                      child: FutureBuilder<List<EventArticle>>(
                          future: list,
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              if(snapshot.data != null){
                                return ListView(
                                  scrollDirection: Axis.vertical,
                                  children: <Widget>[
                                    for(EventArticle dto in snapshot.data)
                                      Container(
                                        height: 350.0,
                                        child: Center(
                                            child: Card(
                                              elevation: 10.0,
                                              shadowColor: Color(0x802196F3),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Image.network(
                                                    dto.eventImageUrl,
                                                    width: 370.0,
                                                    height: 270.0,
                                                  ),
                                                  ListTile(
                                                    title: Text(dto.eventName),
                                                    subtitle: Text(dto.timeOccur),
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                      )
                                  ],
                                );
                              }
                            }
                          }
                      )
                    ),
                  ],
                )),
          )),
    );
  }


}