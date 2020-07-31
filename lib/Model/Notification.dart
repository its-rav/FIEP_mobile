
class Notification{
  String _id, _title, _content;


  Notification(this._id, this._title, this._content);


  String get id => _id;

  factory Notification.fromJson(dynamic json){
    String id;
    if(json['eventId']!= null){
      id = json['eventId'];
    }
    else {
      id = json['groupId'];
    }
    return Notification(
        id,
        json['title'] as String,
        json['body'] as String,
    );
  }

  get title => _title;

  get content => _content;

  set content(value) {
    _content = value;
  }

  set title(value) {
    _title = value;
  }

  set id(String value) {
    _id = value;
  }
}