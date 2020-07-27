class PostDTO{
  String _id;
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


  String get id => _id;


  set id(String value) {
    _id = value;
  }

  factory PostDTO.fromJson(dynamic json){
    return PostDTO(
        json['postId'] as String,
        json['postContent'] as String,
        json['imageUrl'] as String
    );
  }
}