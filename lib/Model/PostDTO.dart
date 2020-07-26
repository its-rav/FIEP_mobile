class PostDTO{
  int _id;
  String _postContent, _imageUrl;

  PostDTO(this._id, this._postContent, this._imageUrl);

  get imageUrl => _imageUrl;

  set imageUrl(value) {
    _imageUrl = value;
  }

  String get postContent => _postContent;

  set postContent(String value) {
    _postContent = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  factory PostDTO.fromJson(dynamic json, int eventID){
    return PostDTO(
        json['postID'] as int,
        json['postContent'] as String,
        json['imageUrl'] as String
    );
  }
}