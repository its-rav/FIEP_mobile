import 'package:fiepapp/FunctionCLasses/signIn.dart';
import 'package:fiepapp/Pages/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomeState createState() {
    // TODO: implement createState
    return new _HomeState();
  }

}

class _HomeState extends State<HomePage> {


  Container MyArticles(String imageVal, String heading, String subHeading){
    return Container(
        width: 250.0,
        child: Card(
          child: Wrap(
            children: <Widget>[
              Image.asset(imageVal,
                width: 250.0,
                height: 250.0,
              ),
              ListTile(
                title: Text(heading),
                subtitle: Text(subHeading),
              )
            ],
          ),
        )
    );
  }
  Container MyClub(String imageVal, String heading){
    return Container(
        width: 250.0,
        child: Card(
          child: Wrap(
            children: <Widget>[
              Image.asset(imageVal,
                width: 250.0,
                height: 250.0,
              ),
              ListTile(
                title: Text(heading),
              ),
              Center(
                child: RaisedButton(
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  elevation: 16,
                  child: Text('Follow Us', style: TextStyle(fontSize: 20.0),),
                  onPressed: () {},
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                ),
              )
            ],
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text("FIEP",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            body:
            Center(
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
                                      prefixIcon: Icon(Icons.search, color: Colors.black),
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
                              onPressed: () {

                              },
                            ),
                          ]
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
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 350,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            MyArticles("images/home/do_an.jpg","K? b?o v? d? án tháng 5/2020 ÐH FPT TP.HCM","13/05/2020"),
                            MyArticles("images/home/talkshow_cv.jpg","Talkshow-livestream: Làm CV chuyên nghi?p có khó nhu b?n nghi? - Take it easy","21/05/2020"),
                            MyArticles("images/home/thankyounote.jpg","Thank you note: Th? thách bày t? lòng bi?t on v?i cu?c s?ng","16/05/2020"),
                            MyArticles("images/home/capstone.jpg","Chu?i Seminar Capstone Companion","30/05/2020"),
                            MyArticles("images/home/byeCovid.jpg","Khai m?c gi?i d?u Bóng dá ByeCovid, chia tay k? ngh? d?ch","20/05/2020"),
                          ],
                        ),
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
                        height: 380,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            MyClub("images/home/fcc.png","Câu l?c b? C? FCC"),
                            MyClub("images/home/fev.jpg","Câu l?c b? t? ch?c s? ki?n FEV"),
                            MyClub("images/home/cocsaigon.jpg","Câu l?c b? truy?n thông Cóc Sài Gòn"),
                            MyClub("images/home/siti.jpg","Câu l?c b? nh?c c? truy?n th?ng"),
                            MyClub("images/home/mec.jpg","Câu l?c b? truy?n thông MEC"),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            )


        ),
    );
  }

}