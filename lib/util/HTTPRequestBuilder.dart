import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dtos.dart';
import '../models/models.dart';

/// Class to build HTTP requests to the backend server.
/// It is a singleton class, so it can be accessed from anywhere in the app.
/// Code by Erik Hinkelmanns, Dannie Krösche, Dorian Zimmermann
class HTTPRequestBuilder {
  static final HTTPRequestBuilder _instance =
  HTTPRequestBuilder._privateConstructor();

  late int userId;
  late String username;
  late String _bearerToken;

  final String _rootURL = "hinkelmanns.org";
  bool _loggedIn = false;

  HTTPRequestBuilder._privateConstructor();

  factory HTTPRequestBuilder() {
    return _instance;
  }

  /// Function to register a new user on the remote server via HTTP POST request.
  /// Code by Dorian Zimmermann
  Future<bool> register(
      {required String name, required String password}) async {
    Uri url = Uri.https(_rootURL, "api/register");
    var response =
    await http.post(url, body: {"name": name, "password": password});
    print('Register: Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print("Register successful");
      return true;
    }
    else {
      print("Response body: ${response.body}");
      return false;
    }
  }

  /// Function to log in a user on the remote server via HTTP POST request.
  /// Code by Erik Hinkelmanns, Dannie Krösche
  Future<void> login({required String name, required String password}) async {
    if (!_loggedIn) {
      Uri url = Uri.https(_rootURL, "api/login");
      var response =
      await http.post(url, body: {"name": name, "password": password});
      print('Login: Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        _bearerToken = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_bearerToken);
        userId = int.parse(decodedToken["id"]);
        username = decodedToken["name"];
        print("User: $username");
        _loggedIn = true;
      } else {
        print("Response body: ${response.body}");
        throw ErrorDescription(
            'Login: Response status: ${response.statusCode}');
      }
    }
  }

  /// Function to log out a user
  /// Code by Dannie Krösche
  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = -1;
    username = "";
    _loggedIn = false;
    _bearerToken = "";
    prefs.clear();
  }

  /// Code by Erik Hinkelmanns
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
    return object['message']["id"];
  }

  /// Function to upload an image file to a remote server via HTTP POST request.
  /// It sends the image file as a multi-part request along with some additional data.
  /// The server's response is then processed, and if the image upload is successful,
  /// it returns the image ID received from the server. Otherwise, it returns 0 as an error code.
  ///
  /// Parameters:
  /// - [file]: The image file to be uploaded.
  ///
  /// Returns:
  /// - [Future<int>]: A `Future` that represents the image ID (if successful) or 0 (if unsuccessful).
  /// Code by Dannie Krösche, Erik Hinkelmanns
  Future<int> createImage({required File file}) async {
    var request = http.MultipartRequest('POST', Uri.https(_rootURL,"api/image"));
    request.headers.addAll({"Authorization": 'Bearer $_bearerToken'});

    request.files.add(
    http.MultipartFile.fromBytes(
        'image',
        file.readAsBytesSync(),
        filename: file.path,
        )
    );

    request.fields['hash'] = file.hashCode.toString();

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    Map<String, dynamic> responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      print("SUCCESS");
      int imageId = responseData['message'];
      return imageId;
    }
    else {
      print(response.statusCode);
      print("ERROR");
      return 0;
    }
  }

  /// Asynchronous method to retrieve an image as raw bytes from a remote server
  /// by making an HTTP GET request with the specified `imageId`.
  ///
  /// Parameters:
  /// - [imageId]: The unique identifier of the image to retrieve.
  ///
  /// Returns:
  /// - [Future<Uint8List>]: A `Future` that represents the image as `Uint8List`
  ///   if the retrieval is successful, or an empty `Uint8List` (length 0) if unsuccessful.
  ///   Code by Dannie Krösche, Erik Hinkelmanns
  Future<Uint8List> getImage({required int? imageId}) async {
    Uri uri = Uri.https(_rootURL, "api/image/$imageId");
    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };

    final response = await http.get(uri, headers: headers);
    Map object = json.decode(response.body);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> dataArray = object['message']['imageBytes']['data'];
      List<int> intArray = dataArray.cast<int>();
      Uint8List imageBytes = Uint8List.fromList(intArray);

      return imageBytes;
    }
    else {
      print(response.statusCode);
    } return Uint8List(0);
  }

  /// Method to send a HTTP GET request to the remote server.
  /// Code by Erik Hinkelmanns, Dorian Zimmermann, Dannie Krösche
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

  /// Method to send a HTTP PUT request to the remote server.
  /// Code by Erik Hinkelmanns, Dorian Zimmermann, Dannie Krösche
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
        return (Expense.fromJson(object["message"]));
      case Category:
        return (Category.fromJson(object["message"]));
    }
    return null;
  }

  /// Method to send a HTTP POST request to the remote server.
  /// Code by Erik Hinkelmanns, Dorian Zimmermann, Dannie Krösche
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

  /// Method to send a HTTP DELETE request to the remote server.
  /// Code by Erik Hinkelmanns, Dorian Zimmermann, Dannie Krösche
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

  /// Returns the username of the currently logged in user.
  /// Code by Erik Hinkelmanns
  String? getUsername() {
    if (_loggedIn) {
      return username;
    } else {
      return null;
    }
  }
}
