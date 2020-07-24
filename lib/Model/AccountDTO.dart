class AccountDTO{

 String _userId, _mail, _name, _imageUrl;


 String get userId => _userId;


 AccountDTO(this._userId, this._mail, this._name, this._imageUrl);

  set userId(String value) {
    _userId = value;
  }

  factory AccountDTO.fromJson(dynamic json){
    return AccountDTO(
        json["userId"] as String,
        json['mail'] as String,
        json['fullName'] as String,
        json['avatarUrl'] as String
    );
  }


 Map<String, dynamic> toJson() {
   return {
     "userId": _userId,
     "mail": _mail,
     "fullName": _name,
     "avatarUrl": _imageUrl,
   };
 }

  get mail => _mail;

  get name => _name;

  get imageUrl => _imageUrl;

 set mail(value) {
    _mail = value;
  }

 set name(value) {
    _name = value;
  }

 set imageUrl(value) {
    _imageUrl = value;
  }
}