
import 'package:fiepapp/Model/GroupDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/group_view.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:fiepapp/ViewModel/group_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AllGroupPage extends StatefulWidget {

  @override
  _SearchResultPage createState() {
    // TODO: implement createState
    return new _SearchResultPage();
  }

  AllGroupPage();
}

class _SearchResultPage extends State<AllGroupPage> {
  // for http requests
  bool isDesc = true;
  GroupViewModel _groupViewModel = new GroupViewModel();

  @override
  void initState() {
    super.initState();
    _groupViewModel.getGroupBy(isDesc);
  }



  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _groupViewModel,
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
                  child: Text('ALL GROUPS',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Timesroman',
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  chooseType(),
                  chooseDesc(),
                ],
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
      child: TextFormField(
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search, color: Colors.black),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: 'Search for events',
            hintStyle: TextStyle(color: Colors.grey)),
        onFieldSubmitted: (String input) {
          if (input.trim().isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SearchResultPage(input)));
          }
        },
      ),
    );
  }

  Widget _searhResult() {
    return ScopedModelDescendant<GroupViewModel>(
        builder: (BuildContext context, Widget child, GroupViewModel model) {
          if (model.list != null && model.list.isNotEmpty) {
            List<Widget> listWidget = new List<Widget>();
            for(GroupDTO dto in model.list){
              listWidget.add(Container(
                height: 330.0,
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
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage(dto.id),));
                      await model.getGroupBy(isDesc);
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
                                padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                child: Text(dto.follower.toString() + " followers"),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ));
            }
            return Column(
              children: <Widget>[
                Column(
                    children: listWidget
                ),
                model.currentPage < model.totalPage ? FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.blue,
                  child: Text("Load more", style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    await model.addGroupBy(isDesc);
                  },
                ) : Text("End of list")
              ],
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

  Widget chooseType(){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: <Widget>[
          Text("Sort by:", style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(width: 10,),
          Text("Followers")
        ],
      ),
    );
  }

  Widget chooseDesc(){
    return ScopedModelDescendant<GroupViewModel>(
      builder:(BuildContext context, Widget child, GroupViewModel model) {
        if(model.list != null && model.list.isNotEmpty){
          List<String> sortList = ['Ascending', 'Descending'];
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: DropdownButton(
              hint: new Text("Select sort"),
              value: isDesc,
              items: sortList.map((e) => DropdownMenuItem(value: e == 'Descending' ? true : false, child: Text(e))).toList(),
              onChanged: (value) async {
                isDesc = value;
                await model.getGroupBy(isDesc);
              },
            ),
          );
        }
        return Container();
      },

    );
  }
}
