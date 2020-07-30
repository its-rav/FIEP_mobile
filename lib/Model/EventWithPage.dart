import 'package:fiepapp/Model/EventDTO.dart';

class EventWithPage{
  List<EventDTO> _list;
  int _currentPage;
  double _totalPage;

  EventWithPage(this._list, this._currentPage, this._totalPage);

  double get totalPage => _totalPage;

  int get currentPage => _currentPage;

  List<EventDTO> get list => _list;

  set totalPage(double value) {
    _totalPage = value;
  }

  set currentPage(int value) {
    _currentPage = value;
  }

  set list(List<EventDTO> value) {
    _list = value;
  }

  factory EventWithPage.fromJson(dynamic json){
    var eventJson = json['data'] as List;
    List<EventDTO> dto =  eventJson.map((e) => EventDTO.fromJson(e)).toList();
    return EventWithPage(
      dto,
      json['currentPage'] as int,
      json['totalPages'] as double
    );
  }
}