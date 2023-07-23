import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dtos.dart';
import '../models/models.dart';

class HTTPRequestBuilder {
  static final HTTPRequestBuilder _instance =
      HTTPRequestBuilder._privateConstructor();

  // Variables were final, but I had to remove the final keyword to make the logout function work
  late int userId;
  late String username;
  late String _bearerToken;

  final String _rootURL = "hinkelmanns.org";
  bool _loggedIn = false;

  HTTPRequestBuilder._privateConstructor();

  factory HTTPRequestBuilder() {
    return _instance;
  }

  Future<void> register(
      {required String name, required String password}) async {
    Uri url = Uri.https(_rootURL, "api/register");
    var response =
        await http.post(url, body: {"name": name, "password": password});
    if (response.statusCode == 200) {
      print("Register successful");
    } else if(response.statusCode == 500) {
      print("User already exists"); //todo - tell UserState -> Register
    }
    else {
      print("Response body: ${response.body}");
    }
    print('Register: Response status: ${response.statusCode}');
  }

  Future<void> login({required String name, required String password}) async {
    if (!_loggedIn) {
      Uri url = Uri.https(_rootURL, "api/login");
      var response =
          await http.post(url, body: {"name": name, "password": password});
      if (response.statusCode == 200) {
        _bearerToken = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_bearerToken);
        userId = int.parse(decodedToken["id"]);
        username = decodedToken["name"];
        print("User: $username");
        _loggedIn = true;
      } else {
        print("Response body: ${response.body}");
        throw ErrorDescription('Login: Response status: ${response.statusCode}');
      }
      print('Login: Response status: ${response.statusCode}');
    }
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = -1;
    username = "";
    _loggedIn = false;
    _bearerToken = "";
    prefs.clear();
  }

  Future<int?> createModel<T extends DTO>(
      {required String path, required T tmp}) async {
    Uri uri = Uri.https(_rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final response = await http.post(uri, headers: headers, body: tmp.toJson());

    print('Response status: ${response.statusCode}');
    print("Response body: ${response.body}");
    Map object = json.decode(response.body);
    return object["id"];
  }

  Future<Object?> get({required String path, required Type returnType}) async {
    Uri uri = Uri.https(_rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final response = await http.get(uri, headers: headers);
    Map object = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    switch (returnType) {
      case Expense:
        return Expense.fromJson(object);
      case List<Expense>:
        List<Expense> temp = [];
        for (var element in (object['message'] as List)) {
          temp.add(Expense.fromJson(element));
        }
        return temp;
      case Category:
        print(object);
        return Category.fromJson(object);
      case List<Category>:
        List<Category> temp = [];
        for (var element in (object['message'] as List)) {
          temp.add(Category.fromJson(element));
        }
        return temp;
    }
    return null;
  }

  Future<Model?> put<T extends DTO>(
      {required String path, required T obj, required Type returnType}) async {
    Uri uri = Uri.https(_rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final response = await http.put(uri, headers: headers, body: obj.toJson());
    Map object = json.decode(response.body);
    switch (returnType) {
      case Expense:
        print(object);
        return (Expense.fromJson(object["message"]));
      case Category:
        print(object);
        return (Category.fromJson(object["message"]));
    }
    return null;
  }

  Future<Model?> post<T extends DTO>(
      {required String path, required T obj, required Type returnType}) async {
    Uri uri = Uri.https(_rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final response = await http.post(uri, headers: headers, body: obj.toJson());
    Map object = json.decode(response.body);
    switch (returnType) {
      case Expense:
        return Expense.fromJson(object);
      case Category:
        return Category.fromJson(object);
    }
    return null;
  }

  delete({required Type deleteType, required objId}) async {
    //Todo refresh local category
    Uri uri;
    switch (deleteType) {
      case Expense:
        uri = Uri.https(_rootURL,
            "api/users/$userId/expenditures/$objId"); //todo - correct to "expense"
        break;
      case Category:
        uri = Uri.https(_rootURL, "api/users/$userId/categories/$objId");
        break;
      default:
        throw ErrorDescription("$deleteType is not a valid Type");
    }
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    final response = await http.delete(uri, headers: headers);
    if (response.statusCode != 200) {
      throw ErrorDescription("$deleteType with id $objId not found");
    }
  }
  bool get loggedIn => _loggedIn;

  set loggedIn(bool state) => _loggedIn = state;



  String? getUsername(){
    if(_loggedIn){
      return username;
    } else {
      return null;
    }
  }
}
