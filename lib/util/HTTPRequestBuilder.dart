import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/dtos.dart';
import '../models/models.dart';

class HTTPRequestBuilder {
  static final HTTPRequestBuilder _instance =
      HTTPRequestBuilder._privateConstructor();

  late final int userId;

  final String rootURL = "hinkelmanns.org";
  late final String bearerToken;
  bool _loggedIn = false;

  HTTPRequestBuilder._privateConstructor();

  factory HTTPRequestBuilder() {
    return _instance;
  }

  void register({required String name, required String password}) async {
    Uri url = Uri.https(rootURL, "api/register");
    await http.post(url, body: {"name": name, "password": password});
  }

  Future<void> login({required String name, required String password}) async {
    if (!_loggedIn) {
      Uri url = Uri.https(rootURL, "api/login");
      var response =
          await http.post(url, body: {"name": name, "password": password});
      if (response.statusCode == 200) {
        bearerToken = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(bearerToken);
        userId = int.parse(decodedToken["id"]);
        print("userID: $userId");
        _loggedIn = true;
      } else {
        print("Response body: ${response.body}");
      }
      print('Login: Response status: ${response.statusCode}');
    }
  }

  Future<int?> createModel<T extends DTO>(
      {required String path, required T tmp}) async {
    Uri uri = Uri.https(rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final response = await http.post(uri, headers: headers, body: tmp.toJson());

    print('Response status: ${response.statusCode}');
    print("Response body: ${response.body}");
    Map object = json.decode(response.body);
    return object["id"];
  }

  Future<Object?> get({required String path, required Type returnType}) async {
    Uri uri = Uri.https(rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final response = await http.get(uri, headers: headers);
    Map object = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    switch (returnType) {
      case Expenditure:
        return Expenditure.fromJson(object);
      case List<Expenditure>:
        List<Expenditure> temp = [];
        for (var element in (object['message'] as List)) {
          temp.add(Expenditure.fromJson(element));
        }
        return temp;
      case Category:
        return Category.fromJson(object);
    }
    return null;
  }

  Future<Model?> put<T extends DTO>(
      {required String path, required T obj, required Type returnType}) async {
    Uri uri = Uri.https(rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final response = await http.put(uri, headers: headers, body: obj.toJson());
    Map object = json.decode(response.body);
    switch (returnType) {
      case Expenditure:
        print(object);
        return (Expenditure.fromJson(object["message"]));
      case Category:
        return Category.fromJson(object);
    }
    return null;
  }

  Future<Model?> post<T extends DTO>(
      {required String path, required T obj, required Type returnType}) async {
    Uri uri = Uri.https(rootURL, "api/users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final response = await http.post(uri, headers: headers, body: obj.toJson());
    Map object = json.decode(response.body);
    switch (returnType) {
      case Expenditure:
        return Expenditure.fromJson(object);
      case Category:
        return Category.fromJson(object);
    }
    return null;
  }

  delete({required Type deleteType, required objId}) async {
    //Todo refresh local category
    Uri uri;
    switch (deleteType) {
      case Expenditure:
        uri = Uri.https(rootURL, "api/users/$userId/expenditures/$objId");
        break;
      case Category:
        uri = Uri.https(rootURL, "api/users/$userId/categories/$objId");
        break;
      default:
        throw ErrorDescription("$deleteType is not a valid Type");
    }
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final response = await http.post(uri, headers: headers);
    if (response.statusCode != 200) {
      throw ErrorDescription("$deleteType with id $objId not found");
    }
  }

// get users from api

}

//Todo build generic method for Http request
//Todo write test method for getting allExpenditures
