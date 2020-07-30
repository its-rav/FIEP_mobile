class GroupSubcription{
  int _groupId;
  String _groupName;


  int get groupId => _groupId;

  GroupSubcription(this._groupId, this._groupName);

  factory GroupSubcription.fromJson(dynamic json){
    return GroupSubcription(
      json['groupId'] as int,
      json['groupName'] as String
    );
  }

  String get groupName => _groupName;

  set groupName(String value) {
    _groupName = value;
  }

  set groupId(int value) {
    _groupId = value;
  }
}