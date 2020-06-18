import 'dart:math';

import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/GroupDAO.dart';
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 15.0),
              Stack(children: <Widget>[

                Container(
                  height: 50,
                  child: ButtonBar(),
                ),

                Positioned(
                  top: MediaQuery.of(context).viewInsets.top,
                  left: 0,
                  right: 0,
                  child: Row(
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
                ),



              ]),

              SizedBox(height: 15.0),
              getGroupUI(),
              getEventUI(),

            ],
          )),
        ));
  }

  @override
  void initState() {
    super.initState();
    dao = new GroupDAO();
    groupDTO = dao.getGroup(2);
    list = dao.getEventofGroup(2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Icon getState(int state) {
    if (state == 1) {
      return Icon(Icons.check_circle, size: 25);
    } else if (state == 0) {
      return Icon(Icons.more, size: 25);
    }

    return Icon(Icons.cancel, size: 25);
  }

  FutureBuilder getGroupUI() {
    return FutureBuilder<GroupDTO>(
        future: groupDTO,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Thằng Nhân tắt máy cmnr :)))");
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(snapshot.data.imageUrl,
                    //height: 150,
                    fit: BoxFit.fill),
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
                                  color: Colors.grey[800])),
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('EVENTS',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Timesroman',
                                fontWeight: FontWeight.bold)),
                        IconButton(
                            icon: Icon(Icons.control_point),
                            iconSize: 30,
                            onPressed: () {}),
                      ]),
                ),
              ]);
        });
  }

  FutureBuilder getEventUI() {
    return FutureBuilder<List<EventDTO>>(
      future: list,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return Column(
              children: <Widget>[
                for (EventDTO dto in snapshot.data)
                  Container(
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
                        onTap: () => print("ciao"),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(dto.imageUrl,
                                  height: 230, fit: BoxFit.fill),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      dto.name,
                                      style: TextStyle(
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'san-serif'),
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            style: BorderStyle.solid,
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Text("Follow",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800])),
                                    )
                                  ]),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Location: " + dto.location,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      (10 + Random().nextInt(900)).toString() +
                                          " Followers",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Time: " +
                                    dto.timeOccur
                                        .toString()
                                        .replaceAll("T", " "),
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Created: " +
                                            dto.createDate
                                                .toString()
                                                .replaceAll("T", " "),
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: getState(dto.aproveSate),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        } else {
          return Text("Nothing to show");
        }
      },
    );
  }
}
