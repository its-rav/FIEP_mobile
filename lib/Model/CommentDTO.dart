class CommentDTO{
  String _id, _userId, _postId, _content;
  DateTime _createDate;

  CommentDTO(this._id, this._userId, this._postId, this._content,
      this._createDate);

  DateTime get createDate => _createDate;

  get content => _content;

  get postId => _postId;

  get userId => _userId;

  String get id => _id;


  set createDate(DateTime value) {
    _createDate = value;
  }

  set content(value) {
    _content = value;
  }

  set postId(value) {
    _postId = value;
  }

  set userId(value) {
    _userId = value;
  }

  set id(String value) {
    _id = value;
  }

  factory CommentDTO.fromJson(dynamic json){
    return CommentDTO(
        json['commentId'] as String,
        json['userId'] as String,
        json['postId'] as String,
        json['commentContent'] as String,
        DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": _userId,
      "postId": _postId,
      "content": _content,
    };
  }


}