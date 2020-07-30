import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/event_all_view.dart';
import 'package:fiepapp/View/event_view.dart';
import 'package:fiepapp/View/group_all_view.dart';
import 'package:fiepapp/View/group_view.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
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
  Future<List<EventDTO>> listPopular;


  @override
  void initState() {
    super.initState();
    dao = new EventDAO();
    listPopular = dao.getPopulatEvent();
    list = dao.getUpcomingEvent();
    groupDAO = new GroupDAO();
    listGroup = groupDAO.get5Group();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar(),
      ),
      endDrawer: drawerMenu(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 15.0),
            Text("Home Page", style: TextStyle(color: Colors.orange, fontSize: 23, fontWeight: FontWeight.bold),),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
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
                    Text('POPULAR EVENTS',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Timesroman',
                            fontWeight: FontWeight.bold)),
                    FlatButton(
                      child: Text("show all", style: TextStyle(color: Colors.blue),),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllEventPage(1)));
                      },
                    ),
                  ],
                ),
              ),
            ),
            mostPopularUI(),
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
                    Text('INCOMING EVENTS',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Timesroman',
                            fontWeight: FontWeight.bold)),
                    FlatButton(
                      child: Text("show all", style: TextStyle(color: Colors.blue),),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllEventPage(0)));
                      },
                    ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('UNIVERSITY CLUBS',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Timesroman',
                            fontWeight: FontWeight.bold)),
                    FlatButton(
                      child: Text("show all", style: TextStyle(color: Colors.blue),),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllGroupPage()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            groupUI()

          ],
        ),
      ),
    );
  }

  Widget searchBar(){
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon:
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
    );
  }

  Widget mostPopularUI(){
    return FutureBuilder<List<EventDTO>>(
        future: listPopular,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data.isNotEmpty) {
              return Container(
                height: 320,
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
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EventPostPage(dto.id)));
                                setState(() {
                                  listPopular = dao.getPopulatEvent();
                                });
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
                                    title:  Center(child: Text(dto.name, style: TextStyle(fontSize: 18,color: Colors.red, fontWeight: FontWeight.bold),)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 5,),
                                        Text(dto.follower.toString() + " followers", style: TextStyle(color: Colors.black),),
                                        Text(DateFormat("dd/MM/yyyy hh:mm a").format(dto.timeOccur))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                  ],
                ),
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("List is empty"),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget eventUI(){
    return FutureBuilder<List<EventDTO>>(
        future: list,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data.isNotEmpty) {
              return Container(
                height: 320,
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
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EventPostPage(dto.id)));
                                list = dao.getUpcomingEvent();
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
                                    title: Center(child: Text(dto.name, style: TextStyle(fontSize: 18,color: Colors.red, fontWeight: FontWeight.bold),)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 5,),
                                          Text(dto.follower.toString() + " followers", style: TextStyle(color: Colors.black),),
                                          Text(DateFormat("dd/MM/yyyy hh:mm a").format(dto.timeOccur))
                                        ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                  ],
                ),
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("List is empty"),
              ),
            );
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
              return Container(
                height: 290,
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
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GroupPage(dtoGroup.id)));
                                listGroup = groupDAO.get5Group();
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
                                    title: Text(dtoGroup.name, style: TextStyle(fontWeight: FontWeight.bold),),
                                    subtitle: Text(dtoGroup.follower.toString() + " followers"),
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

}
