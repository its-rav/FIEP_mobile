class Group {
  final String groupName;
  final String groupImgUrl;
//  final String eventImageUrl;
//  final String eventId;

  Group({this.groupName, this.groupImgUrl});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupName: json['groupName'] as String,
      groupImgUrl: json['groupImgUrl'] as String,
    );
  }
}