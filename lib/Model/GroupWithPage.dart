import 'package:fiepapp/Model/GroupDTO.dart';

class GroupWithPage{
  List<GroupDTO> _list;
  int _currentPage;
  double _totalPage;

  GroupWithPage(this._list, this._currentPage, this._totalPage);

  double get totalPage => _totalPage;

  int get currentPage => _currentPage;

  List<GroupDTO> get list => _list;

  set totalPage(double value) {
    _totalPage = value;
  }

  set currentPage(int value) {
    _currentPage = value;
  }

  set list(List<GroupDTO> value) {
    _list = value;
  }

  factory GroupWithPage.fromJson(dynamic json){
    var eventJson = json['data'] as List;
    List<GroupDTO> dto =  eventJson.map((e) => GroupDTO.fromJson(e)).toList();
    return GroupWithPage(
        dto,
        json['currentPage'] as int,
        json['totalPages'] as double
    );
  }
}