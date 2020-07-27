import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_exception.dart';

class ApiHelper {



  final String _baseUrl = "http://172.20.10.5:8085/api/";

  Future<dynamic> get(String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("TOKEN");
    try {
      final response = await http.get(_baseUrl + url, headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "token" : token
      },

      );
      print("Ahihi URL: " + _baseUrl+url);
      print("Status code: " + response.statusCode.toString());
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> nameValues) async {
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

  Future<dynamic> post02(String url, Map<String, dynamic> nameValues) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("TOKEN");
    try {
      final response = await http.post(
          _baseUrl + url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            'token' : token
          },
          body: jsonEncode(nameValues));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String url, Map<String, dynamic> nameValues) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("TOKEN");
    try {
      final response = await http.patch(
          _baseUrl + url,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            'token' : token
          },
          body: jsonEncode(nameValues));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> delete(String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("TOKEN");
    try {
      final response = await http.delete(_baseUrl + url, headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "token" : token
      },
      );
      print("Ahihi URL: " + _baseUrl+url);
      print("Status code: " + response.statusCode.toString());
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = new Map<String, dynamic>();
        if(response.body.isNotEmpty){
          responseJson = json.decode(response.body);
          print(responseJson);
        }
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 511:
        throw ExpiredException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response
                .statusCode}');
    }
  }

  ApiHelper();
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}