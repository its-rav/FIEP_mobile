import 'package:fiepapp/Model/EventDTO.dart';

class GroupDTO{
  int _id, _follower;
  String _name, _imageUrl;

  GroupDTO(this._id, this._follower, this._name, this._imageUrl);

  get imageUrl => _imageUrl;

  String get name => _name;

  get follower => _follower;

  int get id => _id;

  set imageUrl(value) {
    _imageUrl = value;
  }

  set name(String value) {
    _name = value;
  }

  set follower(value) {
    _follower = value;
  }

  set id(int value) {
    _id = value;
  }


  @override
  String toString() {
    return 'GroupDTO{_id: $_id, _follower: $_follower, _name: $_name, _imageUrl: $_imageUrl}';
  }

  factory GroupDTO.fromJson(dynamic json, int groupID){
    return GroupDTO(
        groupID,
        json['groupFollower'] as int,
        json['groupName'] as String,
        json['groupImageUrl'] as String
    );
  }

  factory GroupDTO.fromJsonAll(dynamic json){
    return GroupDTO(
        json['groupID'] as int,
        json['groupFollower'] as int,
        json['groupName'] as String,
        json['groupImageUrl'] as String
    );
  }
}