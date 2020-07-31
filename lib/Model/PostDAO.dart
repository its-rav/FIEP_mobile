import 'package:fiepapp/API/api_helper.dart';
import 'package:fiepapp/Model/CommentDTO.dart';
import 'package:fiepapp/Model/EventDTO.dart';

import 'PostDTO.dart';

class PostDAO{


  Future<PostDTO> getPost(String posId) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("posts/$posId");
    return PostDTO.fromJson(json);
  }

  Future<List<CommentDTO>> getComments(String postId) async {
    ApiHelper api = new ApiHelper();
    dynamic json = await api.get("posts/$postId/comments");
    if (json['data'] != null) {
      var eventJson = json['data'] as List;
      List<CommentDTO> dto = eventJson.map((e) => CommentDTO.fromJson(e)).toList();
      return dto;
    }
    return null;
  }

  Future<int> addComment(CommentDTO dto) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.post02("comments", dto.toJson());
    if(json != null){
      return 1;
    }
    return 0;
  }

  Future<int> deleteComment(String id) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> json = await api.delete("comments/$id");
    if(json != null){
      return 1;
    }
    return 0;
  }

  Future<int> updateComment(String id, String content) async{
    ApiHelper api = new ApiHelper();
    Map<String, dynamic> map ={'content' : content};
    Map<String, dynamic> json = await api.patch("comments/$id", map);
    if(json != null){
      return 1;
    }
    return 0;
  }

}