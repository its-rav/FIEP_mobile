import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiHelper {



  final String _baseUrl = "https://fiepapi.azurewebsites.net/api/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      print(_baseUrl+url);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, String> nameValues) async {
    var responseJson;
    try {
      final response = await http.post(
          _baseUrl + url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode(nameValues));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response
                .statusCode}');
    }
  }

  ApiHelper();
}