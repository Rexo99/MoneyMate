import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/dtos.dart';
import '../models/models.dart';

class HTTPRequestBuilder {
  static final HTTPRequestBuilder _instance =
      HTTPRequestBuilder._privateConstructor();

  late final int userId;

  //final String rootURL = "192.168.0.136:6060";
  final String rootURL = "141.71.164.168:6060";
  late final String bearerToken;

  HTTPRequestBuilder._privateConstructor();

  factory HTTPRequestBuilder() {
    return _instance;
  }

  void register({required String name, required String password}) async {
    Uri url = Uri.http(rootURL, "register");
    var response =
        await http.post(url, body: {"name": name, "password": password});
    print('Response status: ${response.statusCode}');
  }

  void login({required String name, required String password}) async {
    Uri url = Uri.http(rootURL, "login");
    var response =
        await http.post(url, body: {"name": name, "password": password});
    print('Response status: ${response.statusCode}');
    bearerToken = response.body;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(bearerToken);
    userId = int.parse(decodedToken["id"]);
    print(bearerToken);
  }

  Future<int?> createModel<T extends DTO>({required String path,required T tmp}) async {
    Uri uri = Uri.http(rootURL, "users/$userId/$path");
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

  Future get<T extends Model>(
      {required Uri url, required String bearerToken, required T tmp}) async {
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    });
    Map object = json.decode(response.body);
    return Expenditure.fromJson(object);
  }

  Future<void> put({
    required url,
    required bearerToken,
  }) async {
    final response = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    });
  }

  Future<void> post({
    required url,
    required bearerToken,
  }) async {
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    });
  }

  Future<void> delete({
    required url,
    required bearerToken,
  }) async {
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    });
  }

// get users from api

}

//Todo build generic method for Http request
//Todo write test method for getting allExpenditures
