import 'dart:async';
import 'dart:convert';

import 'package:fiepapp/View/event_view.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => new _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://171.235.181.73:8081/api/events"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      Map<String, dynamic> map = json.decode(response.body);
      data = map['data'];
      print("Data Length: " + data.length.toString());
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
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
                            contentPadding:
                            EdgeInsets.only(left: 15.0, top: 15.0),
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
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventPostPage()));
                        },
                        child: new Padding(
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
                                  child: new Image.network(
                                      data[index]['imageUrl']
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: new Radius.circular(16.0),
                                      topRight: new Radius.circular(16.0)
                                  ),
                                ),
                                new Padding(
                                  padding: new EdgeInsets.all(16.0),
                                  child: new Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[index]["eventName"]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              wordSpacing: 5.0,
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'san-serif'
                                          ),
                                        ),
                                      ),
                                      new SizedBox(height: 15.0),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[index]['location'],
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
                                          data[index]['timeOccur'],
                                          style: TextStyle(
                                              wordSpacing: 3.0,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}