import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/View/event_home.dart';
import 'package:fiepapp/View/group_view.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:flutter/material.dart';

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
  GroupDAO groupDAO ;
  Future<List<GroupDTO>> listGroup;
  @override
  void initState(){
    super.initState();
    dao = new EventDAO();
    list = dao.getAllEvent();
    groupDAO = new GroupDAO();
    listGroup = groupDAO.getAllGroup();
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
                                onFieldSubmitted: (String input){
                                  if(input.trim().isNotEmpty)
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage(input) ));
                                },
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
                        child: FutureBuilder<List<EventDTO>>(
                            future: list,
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                if(snapshot.data != null){
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      for(EventDTO dto in snapshot.data)
                                        Container(
                                            width: 250.0,
                                            child: Card(
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EventPage()));
                                                },
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Image.network(
                                                      dto.imageUrl,
                                                      width: 250.0,
                                                      height: 250.0,
                                                    ),
                                                    ListTile(
                                                      title: Text(dto.name),
                                                      subtitle: Text(dto.timeOccur),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        )
                                    ],
                                  );
                                }
                              }
                              return Container();
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
                        child: FutureBuilder<List<GroupDTO>>(
                            future: listGroup,
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                if(snapshot.data != null){
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      for(GroupDTO dtoGroup in snapshot.data)
                                        Container(
                                            width: 250.0,
                                            child: Card(
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage(dtoGroup.id)));
                                                },
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Image.network(
                                                      dtoGroup.imageUrl,
                                                      width: 250.0,
                                                      height: 250.0,
                                                    ),
                                                    ListTile(
                                                      title: Text(dtoGroup.name),
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
                                              ),
                                            )
                                        )
                                    ],
                                  );
                                }
                              }
                              return Container();
                            }
                        )
                    ),
                  ],
                )),
          )),
    );
  }
}
