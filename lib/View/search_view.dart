import 'dart:convert';

import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/event_view.dart';
import 'package:fiepapp/ViewModel/follow_viewmodel.dart';
import 'package:fiepapp/ViewModel/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResultPage extends StatefulWidget {
  String text;

  @override
  _SearchResultPage createState() {
    // TODO: implement createState
    return new _SearchResultPage();
  }

  SearchResultPage(this.text);
}

class _SearchResultPage extends State<SearchResultPage> {
  // for http requests
  List<int> listFollowEvent = new List<int>();

  SearchViewModel _searchViewModel = new SearchViewModel();
  String value;
  @override
  void initState() {
    super.initState();
    if(widget.text != null){
      value = widget.text;
    }
  }



  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _searchViewModel,
      child: Scaffold(
          appBar: AppBar(
            title: _searchBar()
          ),
          endDrawer: drawerMenu(context),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15.0),
                Center(child: Text("Search Page", style: TextStyle(color: Colors.orange, fontSize: 23, fontWeight: FontWeight.bold),)),
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
                    child: Text('SEARCH RESULT',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Timesroman',
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _searhResult()
              ],
            ),
          ),
          ),

    );
  }

  Widget _searchBar() {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(10.0),
      child: ScopedModelDescendant<SearchViewModel>(builder:
          (BuildContext context, Widget child, SearchViewModel model) {
        return TextFormField(
          initialValue: widget.text,
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: Colors.black),
              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
              hintText: 'Search for events',
              hintStyle: TextStyle(color: Colors.grey)),
          onFieldSubmitted: (String input) {
            if (input.trim().isNotEmpty) {
              value = input;
              model.getEventResult(value);
            }
          },
        );
      }),
    );
  }

  Widget _searhResult() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if(snapshot.hasData){
          String user = snapshot.data.getString("USER");
          Map<String, dynamic> map = jsonDecode(user);
          return ScopedModelDescendant<SearchViewModel>(
              builder: (BuildContext context, Widget child, SearchViewModel model) {
                if (widget.text != null) {
                  model.getEventResult(widget.text);
                  widget.text = null;
                }
                if (model.list != null && model.list.isNotEmpty) {
                  if(map['follow event'] != null){
                    listFollowEvent = map['follow event'].cast<int>();
                  }
                  String d1 = DateFormat("dd/MM/yyyy").format(DateTime.now());
                  List<Widget> listWidget = new List<Widget>();
                  for(EventDTO dto in model.list){
                    String d2 = DateFormat("dd/MM/yyyy").format(dto.timeOccur);
                    String status = "End";
                    Color color = Colors.blue;
                    bool canFollow = false;
                    if(dto.timeOccur.isBefore(DateTime.now()) || dto.timeOccur.difference(DateTime.now()).inDays == 0){
                      if(d1 == d2){
                        status = "Current";
                        color = Colors.green;
                      }
                    }
                    else if(dto.timeOccur.isAfter(DateTime.now())){
                      canFollow = true;
                        status = "Coming";
                        color = Colors.red;
                    }
                    listWidget.add(Container(
                      height: 400.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        elevation: 10.0,
                        shadowColor: Color(0x802196F3),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => EventPostPage(dto.id),));
                            await _searchViewModel.getEventResult(value);
                            SharedPreferences sp = await SharedPreferences.getInstance();
                            String user = sp.getString("USER");
                            Map<String, dynamic> map = jsonDecode(user);
                            setState(() {
                              listFollowEvent = new List<int>();
                              if(map['follow event'] != null){
                                listFollowEvent = map['follow event'].cast<int>();
                              }
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
                                child: Text(
                                  dto.name,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'san-serif'),
                                ),
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
                                              SizedBox(
                                                width: 5,
                                              ),
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
                                          ),
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
                                    canFollow ? Center(child: followButtonEvent(listFollowEvent, dto.id, map)) : Container()

                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ));
                  }
                  return Column(
                    children: listWidget
                  );
                } else if (model.isLoading) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (model.error) {
                  return Text("An Error has occured!");
                }
                return Center(child: Text("Nothing found here"));
              });
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget followButtonEvent(List<int> listFollowEvent, int id, Map<String, dynamic> map){
    return ScopedModel(
      model: new FollowViewModel(),
      child: ScopedModelDescendant<FollowViewModel>(
        builder: (BuildContext context, Widget child, FollowViewModel model) {
          model.getFollowEventStatus(listFollowEvent, id);
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
                    listFollowEvent.add(id);
                  } else listFollowEvent.removeWhere((element) => element == id);
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  map['follow event'] = listFollowEvent;
                  sp.setString("USER", jsonEncode(map));
                  await _searchViewModel.getEventResult(value);

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


}
