class EventDTO {
  int _id, _aproveSate, _follower;
  String _name, _imageUrl, _location, _createDate;
  DateTime _timeOccur;

  EventDTO(this._id, this._aproveSate, this._name, this._imageUrl,
      this._location, this._timeOccur, this._createDate, this._follower);

  get follower => _follower;


  set follower(value) {
    _follower = value;
  }



  get imageUrl => _imageUrl;

  String get name => _name;

  int get id => _id;


  DateTime get timeOccur => _timeOccur;

  set timeOccur(DateTime value) {
    _timeOccur = value;
  }

  set imageUrl(value) {
    _imageUrl = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(int value) {
    _id = value;
  }

  get aproveSate => _aproveSate;

  get location => _location;

  get createDate => _createDate;

  set aproveSate(value) {
    _aproveSate = value;
  }

  set location(value) {
    _location = value;
  }

  set createDate(value) {
    _createDate = value;
  }


  @override
  String toString() {
    return 'EventDTO{_id: $_id, _aproveSate: $_aproveSate, _follower: $_follower, _name: $_name, _imageUrl: $_imageUrl, _location: $_location, _timeOccur: $_timeOccur, _createDate: $_createDate}';
  }



  factory EventDTO.fromJson(dynamic json) {
    int id;
    if(json['eventId']!= null){
      id = json['eventId'] as int;
    }
    else {
      id = json['eventID'] as int;
    }
    return EventDTO(
      id,
      json['approveState'] as int,
      json['eventName'] as String,
      json['eventImageUrl'] as String,
      json['location'] as String,
      DateTime.parse(json['timeOccur']),
      json['createDate'] as String,
        json['follower'] as int
    );
  }

}
