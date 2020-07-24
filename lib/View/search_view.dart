import 'package:fiepapp/Model/EventDAO.dart';
import 'package:fiepapp/Model/EventDTO.dart';
import 'package:fiepapp/View/drawer.dart';
import 'package:fiepapp/ViewModel/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: new SearchViewModel(),
      child: WillPopScope(
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
            endDrawer: drawerMenu(context),
            body: Center(
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
                        _searchBar(),
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
                  SizedBox(
                    height: 15,
                  ),
                  _searhResult()
                ],
              )),
            )),

    );
  }

  Widget _searchBar() {
    return Flexible(
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(25.0),
        child: ScopedModelDescendant<SearchViewModel>(builder:
            (BuildContext context, Widget child, SearchViewModel model) {
          return TextFormField(
            initialValue: widget.text,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.black),
                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                hintText: 'Search for events',
                hintStyle: TextStyle(color: Colors.grey)),
            onFieldSubmitted: (String input) {
              if (input.trim().isNotEmpty) model.getEventResult(input);
            },
          );
        }),
      ),
    );
  }

  Widget _searhResult() {
    return ScopedModelDescendant<SearchViewModel>(
        builder: (BuildContext context, Widget child, SearchViewModel model) {
      if (widget.text != null) {
        model.getEventResult(widget.text);
        widget.text = null;
      }
      if (model.list != null && model.list.isNotEmpty) {
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            height: 400,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                for (EventDTO dto in model.list)
                  Container(
                    height: 350.0,
                    child: Center(
                        child: Card(
                      elevation: 10.0,
                      shadowColor: Color(0x802196F3),
                      child: Wrap(
                        children: <Widget>[
                          Image.network(
                            dto.imageUrl,
                            width: 370.0,
                            height: 270.0,
                          ),
                          ListTile(
                            title: Text(dto.name),
                            subtitle: Text(dto.timeOccur),
                          )
                        ],
                      ),
                    )),
                  )
              ],
            ));
      } else if (model.isLoading) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CircularProgressIndicator(),
        );
      } else if (model.error) {
        return Text("An Error has occured!");
      }
      return Text("Nothing found here");
    });
  }
}
