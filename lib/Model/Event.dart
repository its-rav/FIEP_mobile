class EventArticle {
  final String eventName;
  final String timeOccur;
  final String eventImageUrl;
//  final String eventId;

  EventArticle({this.eventName, this.timeOccur, this.eventImageUrl});
  EventArticle.fromJson(Map<String, dynamic> json):
        this.eventName = json['eventName'],
        this.timeOccur = json['timeOccur'],
        this.eventImageUrl = json['eventImageUrl'];
  Map<String, dynamic> toJson() => {
    'eventName':this.eventName,
    'timeOccur':this.timeOccur,
    'eventImageUrl':this.eventImageUrl
  };
}



