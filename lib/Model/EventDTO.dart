class EventDTO {
  int _id, _aproveSate;
  String _name, _imageUrl, _location, _timeOccur, _createDate;

  EventDTO(this._id, this._aproveSate, this._name, this._imageUrl,
      this._location, this._timeOccur, this._createDate);

  String get timeOccur => _timeOccur;

  get imageUrl => _imageUrl;

  String get name => _name;

  int get id => _id;

  set timeOccur(String value) {
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

  factory EventDTO.fromJson(dynamic json, int id) {
    return EventDTO(
      json['eventID'] as int,
      json['approveState'] as int,
      json['eventName'] as String,
      json['imageUrl'] as String,
      json['location'] as String,
      json['timeOccur'] as String,
      json['createDate'] as String,
    );
  }
}
