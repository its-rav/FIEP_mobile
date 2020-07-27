import 'dart:convert';

import 'package:fiepapp/Accessories/alert.dart';
import 'package:fiepapp/Model/AccountDAO.dart';
import 'package:fiepapp/Model/AccountDTO.dart';
import 'package:fiepapp/Model/CommentDTO.dart';
import 'package:fiepapp/Model/PostDAO.dart';
import 'package:fiepapp/Model/PostDTO.dart';
import 'package:fiepapp/View/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';
import 'search_view.dart';

class PostPage extends StatefulWidget {
  String postId;
  PostPage(this.postId);
  @override
  _EventPostPageState createState() => new _EventPostPageState();
}

class _EventPostPageState extends State<PostPage> {

  String defaultImage = "https://firebasestorage.googleapis.com/v0/b/fiep-e6602.appspot.com/o/users%2Fphoto-1-1590058860284452690018.jpg?alt=media&token=84430471-8893-4d2e-b233-638f702538a8";

  Future<PostDTO> _eventDTO;
  Future<List<CommentDTO>> _listData;
  AccountDAO dao = new  AccountDAO();
  PostDAO postDao = new PostDAO();

  @override
  void initState() {
    super.initState();
    _eventDTO = postDao.getPost(widget.postId);
    _listData = postDao.getComments(widget.postId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawerMenu(context),
        appBar: AppBar(
          title: Text("Post"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                  ],
                ),
                SizedBox(height: 10.0),
                _eventUI(),
                commentBar(),
                _commentUI(),
              ],
            ),
          ),
        ));
  }

  FutureBuilder _eventUI() {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if(snapshot.hasData){
            String user = snapshot.data.getString("USER");
            Map<String, dynamic> map = jsonDecode(user);
            return FutureBuilder<PostDTO>(
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.orange,
                                      style: BorderStyle.solid,
                                      width: 3.0))),
                          child: Text('Comments',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Timesroman',
                                  fontWeight: FontWeight.bold)),
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
  
  Widget commentBar(){
    GlobalKey<FormState> key = new GlobalKey();
    return Material(
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
                    border: InputBorder.none,
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
              icon: Icon(Icons.send),
              onPressed: (){
                if(key.currentState.validate()){
                  key.currentState.save();
                }
              },
            )
          ],

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
                          cmtDate = DateFormat("hh:mm a").format(dto.createDate);
                        }
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
                                    trailing: Text(cmtDate),
                                  ),
                                  secondaryActions: <Widget>[
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
                                trailing: Text(cmtDate),
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

}
