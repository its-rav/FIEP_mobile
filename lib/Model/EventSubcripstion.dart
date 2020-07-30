class EventSubcription{
  int _eventId;
  String _eventName;


  int get eventId => _eventId;

  EventSubcription(this._eventId, this._eventName);

  factory EventSubcription.fromJson(dynamic json){
    return EventSubcription(
        json['eventId'] as int,
        json['eventName'] as String
    );
  }

  String get eventName => _eventName;

  set eventName(String value) {
    _eventName = value;
  }

  set eventId(int value) {
    _eventId = value;
  }
}