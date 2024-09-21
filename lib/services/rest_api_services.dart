import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/services/exception_handling/api_exceptions.dart';

class RestApiServices {
  //Get Data
  Future<dynamic> getRequest(String url) async {
    final response = await http.get(Uri.parse(url));
    final jsonData = processResponse(response);
    return jsonData;
  }

  //Post Data
  Future<void> postRequest(
      {required String postUrl,
      required String title,
      required String description}) async {
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final response = await http.post(Uri.parse(postUrl),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      print("Creation Successfull");
    } else {
      print("not created");
    }
  }

  //Delete Request....
  Future<void> deleteRequest(
      {required String deleteUrl, required String id}) async {
    final response = await http.delete(
      Uri.parse(deleteUrl + id),
    );
    if (response.statusCode == 200) {
      print("deleted");
    }
  }

  //Put Request....
  Future<void> putRequest(
      {required String putUrl,
      required String title,
      required String description,
      required String id}) async {
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final response = await http.put(Uri.parse(putUrl + id),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print("Updated Successfully");
    }
  }

  dynamic processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonData = jsonDecode(response.body);
        print("Data Fetched");
        return jsonData;
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 206:
      case 207:
      case 208:
      case 209:
      case 210:
        return utf8.decode(response.bodyBytes);
      case 400:
        throw FetchDataException(utf8.decode(response.bodyBytes));
      case 401:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes));
      case 403:
        throw AccountDisabledException(utf8.decode(response.bodyBytes));
      case 404:
        throw ResourceNotFoundException(utf8.decode(response.bodyBytes));
      case 422:
        throw UserInputError(utf8.decode(response.bodyBytes));
      case 429:
        throw TooManyAttemptsException("Too Many Attempts!");
      case 500:
        throw InternalServerException(utf8.decode(response.bodyBytes));
      case 502:
        throw NoInternetConnection(utf8.decode(response.bodyBytes));
      default:
        throw FetchDataException(utf8.decode(response.bodyBytes));
    }
  }
}
