class PostDTO{
  String _id;
  String _postContent, _imageUrl;
  DateTime _createDate;

  PostDTO(this._id, this._postContent, this._imageUrl, this._createDate);


  DateTime get createDate => _createDate;


  set createDate(DateTime value) {
    _createDate = value;
  }

  get imageUrl => _imageUrl;

  set imageUrl(value) {
    _imageUrl = value;
  }

  String get postContent => _postContent;

  set postContent(String value) {
    _postContent = value;
  }


  String get id => _id;


  set id(String value) {
    _id = value;
  }

  factory PostDTO.fromJson(dynamic json){
    return PostDTO(
        json['postId'] as String,
        json['postContent'] as String,
        json['imageUrl'] as String,
      DateTime.parse(json['createDate'])
    );
  }
}