import 'dart:convert';

import 'package:fiepapp/Accessories/alert.dart';
import 'package:fiepapp/Model/AccountDAO.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/CommentDTO.dart';
import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/Model/PostDAO.dart';
import 'package:fiepapp/Model/PostDTO.dart';
import 'package:fiepapp/View/event_view.dart';
import 'package:fiepapp/View/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';
import 'search_view.dart';

class PostPage extends StatefulWidget {
  String postId;
  int eventId;
  PostPage(this.postId, this.eventId);
  @override
  _EventPostPageState createState() => new _EventPostPageState();
}

class _EventPostPageState extends State<PostPage> {

  String defaultImage = "https://firebasestorage.googleapis.com/v0/b/fiep-e6602.appspot.com/o/users%2Fphoto-1-1590058860284452690018.jpg?alt=media&token=84430471-8893-4d2e-b233-638f702538a8";

  Future<PostDTO> _postDTO;
  Future<List<CommentDTO>> _listData;
  AccountDAO dao = new  AccountDAO();
  PostDAO postDao = new PostDAO();
  EventDAO _eventDAO = new EventDAO();

  @override
  void initState() {
    super.initState();
    _postDTO = postDao.getPost(widget.postId);
    _listData = postDao.getComments(widget.postId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawerMenu(context),
        appBar: AppBar(
          title: _searchbar(),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                Center(child: Text("Post Page", style: TextStyle(color: Colors.orange, fontSize: 23, fontWeight: FontWeight.bold),)),
                SizedBox(height: 10.0),
                event(),
                _postUI(),
                commentBar(),
                _commentUI(),
              ],
            ),
          ),
        ));
  }

  Widget _searchbar(){
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: Colors.grey,
      child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search, color: Colors.black),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onFieldSubmitted: (String input){
            if(input.trim().isNotEmpty)
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage(input) ));
          }
      ),
    );
  }

  FutureBuilder _postUI() {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if(snapshot.hasData){
            return FutureBuilder<PostDTO>(
                future: _postDTO,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(DateFormat("dd/MM/yyyy hh:mm a").format(snapshot.data.createDate)),
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(snapshot.data.imageUrl,
                              //height: 150,
                              fit: BoxFit.fill),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                          child: Text(
                            snapshot.data.postContent,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 2.0
                                )
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.chat_bubble_outline, color: Colors.grey,),
                              SizedBox(width: 10,),
                              Text('Comment',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold, color: Colors.grey)),
                            ]
                          ),
                        ),
                      ]);
                });
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
    );
  }

  Widget event(){
    return FutureBuilder<EventDTO>(
      future: _eventDAO.getEvent(widget.eventId),
      builder: (BuildContext context, AsyncSnapshot<EventDTO> snapshot) {
        if(snapshot.hasData){
          return FlatButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EventPostPage(widget.eventId) ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  snapshot.data.imageUrl != null ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.grey),
                        shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(snapshot.data.imageUrl),
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ) : Container(),
                  SizedBox(width: 10,),
                  Flexible(child: Text(snapshot.data.name, style: TextStyle(color: Colors.blue, fontSize: 23),))
                ],
              ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Container()
        );

      },
    );
  }
  
  Widget commentBar(){
    GlobalKey<FormState> key = new GlobalKey();
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(25.0),
        shadowColor: Colors.grey,
        child: Form(
          key: key,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      hintText: 'Add comment',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSaved: (String input) async {
                      if(input.trim().isNotEmpty){
                        alertNoti(context, "Please wait", CircularProgressIndicator());
                        SharedPreferences sp = await SharedPreferences.getInstance();
                        String user = sp.getString("USER");
                        if(user != null){
                          AccountDTO acc = AccountDTO.fromJson(jsonDecode(user)['account']);
                          PostDAO dao = new PostDAO();
                          CommentDTO dto = new CommentDTO("0", acc.userId, widget.postId, input, DateTime.now());
                          int result = await dao.addComment(dto);
                          if(result > 0){
                            setState(() {
                              _listData = postDao.getComments(widget.postId);
                            });
                          }
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      }
                    }
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue,),
                onPressed: (){
                  if(key.currentState.validate()){
                    key.currentState.save();
                  }
                },
              )
            ],

          ),
        ),
      ),
    );
  }

  FutureBuilder _commentUI() {
    return FutureBuilder<List<CommentDTO>>(
        future: _listData,
        builder: (BuildContext context, AsyncSnapshot<List<CommentDTO>> snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.data.toString());
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("No comments"),
            );
          } else {
            return Column(
              children: <Widget>[
                for (CommentDTO dto in snapshot.data)
                  FutureBuilder(
                    future: dao.getAccount(dto.userId),
                    builder: (BuildContext context, AsyncSnapshot<AccountDTO> snapshot) {
                      if(snapshot.hasData){
                        String now = DateFormat("dd/MM/yyyy").format(DateTime.now());
                        String cmtDate = DateFormat("dd/MM/yyyy").format(dto.createDate);
                        if(now == cmtDate){
                          cmtDate = "Today";
                        }
                        String cmtTime = DateFormat("hh:mm a").format(dto.createDate);
                        String image = defaultImage;
                        if(snapshot.data.imageUrl != null){
                          image = snapshot.data.imageUrl;
                        }
                        AccountDTO owner = snapshot.data;
                        return FutureBuilder<SharedPreferences>(
                          future: SharedPreferences.getInstance(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              String user = snapshot.data.getString("USER");
                              AccountDTO acc = AccountDTO.fromJson(jsonDecode(user)['account']);
                              if(acc.userId == owner.userId){
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: ListTile(
                                    leading: ClipOval(
                                      child: Image(
                                        image: NetworkImage(image),
                                        width: 50.0,
                                        height: 50.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(owner) ));
                                        },
                                        child: Text(owner.name)),
                                    subtitle: Text(dto.content),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(cmtDate),
                                        SizedBox(height: 5,),
                                        Text(cmtTime)
                                      ],
                                    ),
                                  ),

                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                        caption: 'Edit',
                                        color: Colors.blue,
                                        icon: Icons.edit,
                                        onTap: () async {
                                          String text = await showEditText(dto.content, context);
                                          if(text != dto.content){
                                            alertNoti(context, "Please wait", CircularProgressIndicator());
                                            int result = await postDao.updateComment(dto.id, text);
                                            if(result > 0){
                                              setState(() {
                                                _listData = postDao.getComments(widget.postId);
                                              });
                                            }
                                            Navigator.of(context, rootNavigator: true).pop();
                                          }
                                        }
                                    ),
                                IconSlideAction(
                                caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () async {
                                      alertNoti(context, "Please wait", CircularProgressIndicator());
                                      int result = await postDao.deleteComment(dto.id);
                                      if(result > 0){
                                        setState(() {
                                          _listData = postDao.getComments(widget.postId);
                                        });
                                      }
                                      Navigator.of(context, rootNavigator: true).pop();

                                    }
                                ),
                                  ],
                                );
                              }
                              return ListTile(
                                leading: ClipOval(
                                  child: Image(
                                    image: NetworkImage(image),
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(owner) ));
                                  },
                                    child: Text(owner.name)),
                                subtitle: Text(dto.content),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(cmtDate),
                                      SizedBox(height: 5,),
                                      Text(cmtTime)
                                    ],
                                    ),
                              );
                            }
                            return Container();
                          },
                        );
                      }
                      return Container();
                    },
                  ),
              ],
            );
          }
        });
  }

  Future<String> showEditText(String text, BuildContext context) async {
    GlobalKey<FormState> golbal = new GlobalKey<FormState>();
    String newText = text;
    await showDialog( context: context, builder: (BuildContext context) {
      return Dialog(
        child: Form(
          key: golbal,
          child: Column(
              mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: text,
                  validator: (value) {
                    if(value.trim().isEmpty){
                      return "Text is not empty";
                    }
                  },
                  onSaved: (newValue) {
                    newText = newValue;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.blue,
                    child: Text("Save",
                        style: TextStyle(color: Colors.blue)),
                    onPressed: (){
                      if(golbal.currentState.validate()){
                        golbal.currentState.save();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.blue,
                    child: Text("Cancel",
                        style: TextStyle(color: Colors.blue)),
                    onPressed: (){
                        Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],

          ),
        ),
      );
    },);
    return newText;
  }

}
