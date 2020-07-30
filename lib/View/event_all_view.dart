
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/View/event_view.dart';
import 'package:fiepapp/View/search_view.dart';
import 'package:fiepapp/ViewModel/event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class AllEventPage extends StatefulWidget {

  int type;

  @override
  _SearchResultPage createState() {
    // TODO: implement createState
    return new _SearchResultPage();
  }

  AllEventPage(this.type);
}

class _SearchResultPage extends State<AllEventPage> {
  // for http requests
  List<int> listFollowEvent = new List<int>();
  bool isDesc = true;

  EventViewModel _eventViewModel = new EventViewModel();
  String value;
  @override
  void initState() {
    super.initState();
    _eventViewModel.getEventBy(widget.type, isDesc);
  }



  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _eventViewModel,
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
                  child: Text('ALL EVENTS',
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
    return ScopedModelDescendant<EventViewModel>(
        builder: (BuildContext context, Widget child, EventViewModel model) {
          if (model.list != null && model.list.isNotEmpty) {
            String d1 = DateFormat("dd/MM/yyyy").format(DateTime.now());
            List<Widget> listWidget = new List<Widget>();
            for(EventDTO dto in model.list){
              String d2 = DateFormat("dd/MM/yyyy").format(dto.timeOccur);
              String status = "End";
              Color color = Colors.blue;
              if(dto.timeOccur.isBefore(DateTime.now()) || dto.timeOccur.difference(DateTime.now()).inDays == 0){
                if(d1 == d2){
                  status = "Current";
                  color = Colors.green;
                }
              }
              else if(dto.timeOccur.isAfter(DateTime.now())){
                status = "Coming";
                color = Colors.red;
              }
              listWidget.add(Container(
                height: 380.0,
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
                      await _eventViewModel.getEventBy(widget.type, isDesc);
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
                                    )
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
                  child: Text("Load more" ,style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    await model.addEventBy(widget.type, isDesc);
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
    return ScopedModelDescendant<EventViewModel>(
      builder:(BuildContext context, Widget child, EventViewModel model) {
        if(model.list != null && model.list.isNotEmpty){
          List<String> sortList = ['Date', 'Follower'];
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: <Widget>[
                Text("Sort by:", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(width: 10,),
                DropdownButton(
                  hint: new Text("Select sort"),
                  value: widget.type,
                  items: sortList.map((e) => DropdownMenuItem(value: e == 'Date' ? 0 : 1, child: Text(e))).toList(),
                  onChanged: (value) async {
                    widget.type = value;
                    await model.getEventBy(widget.type, isDesc);
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },

    );
  }

  Widget chooseDesc(){
    return ScopedModelDescendant<EventViewModel>(
      builder:(BuildContext context, Widget child, EventViewModel model) {
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
                await model.getEventBy(widget.type, isDesc);
              },
            ),
          );
        }
        return Container();
      },

    );
  }



}
