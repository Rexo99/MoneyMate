import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/dtos.dart';
import '../models/models.dart';

class HTTPRequestBuilder {
  static final HTTPRequestBuilder _instance =
      HTTPRequestBuilder._privateConstructor();

  late final int userId;

  //final String rootURL = "192.168.0.136:6060";
  final String rootURL = "45.129.181.24:6060";
  late final String bearerToken;

  HTTPRequestBuilder._privateConstructor();

  factory HTTPRequestBuilder() {
    return _instance;
  }

  void register({required String name, required String password}) async {
    Uri url = Uri.http(rootURL, "register");
    await http.post(url, body: {"name": name, "password": password});
  }

  void login({required String name, required String password}) async {
    Uri url = Uri.http(rootURL, "login");
    var response =
        await http.post(url, body: {"name": name, "password": password});
    bearerToken = response.body;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(bearerToken);
    userId = int.parse(decodedToken["id"]);
    print('Login: Response status: ${response.statusCode}');
  }

  Future<int?> createModel<T extends DTO>(
      {required String path, required T tmp}) async {
    Uri uri = Uri.http(rootURL, "users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final response = await http.post(uri, headers: headers, body: tmp.toJson());

    //print('Response status: ${response.statusCode}');
    //print("Response body: ${response.body}");
    Map object = json.decode(response.body);
    return object["id"];
  }

  Future<Model?> get({required String path, required Type returnType}) async {
    Uri uri = Uri.http(rootURL, "users/$userId/$path");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    final response = await http.get(uri, headers: headers);
    Map object = json.decode(response.body);
    switch (returnType) {
      case Expenditure:
        return Expenditure.fromJson(object);
      case Category:
        return Category.fromJson(object);
    }
    return null;
  }

  Future<Model?> put<T extends DTO>({required String path, required T obj,required Type returnType}) async {
  Uri uri = Uri.http(rootURL, "users/$userId/$path");
  Map<String, String>? headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer $bearerToken',
  };
  final response = await http.put(uri, headers: headers, body: obj.toJson());
  Map object = json.decode(response.body);
  switch (returnType) {
  case Expenditure:
  return Expenditure.fromJson(object);
  case Category:
  return Category.fromJson(object);
  }
  return null;
  }

  Future<Model?> post<T extends DTO>({required String path, required T obj,required Type returnType}) async {
    Uri uri = Uri.http(rootURL, "users/$userId/$path");
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
        uri = Uri.http(rootURL, "users/$userId/expenditures/$objId");
        break;
      case Category:
        uri = Uri.http(rootURL, "users/$userId/categories/$objId");
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
    if(response.statusCode != 200) {
      throw ErrorDescription("$deleteType with id $objId not found");
    }

  }

// get users from api

}

//Todo build generic method for Http request
//Todo write test method for getting allExpenditures
