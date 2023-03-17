import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cash_crab/util/HTTPRequestBuilder.dart';
import 'package:flutter/cupertino.dart';

class UserState extends InheritedWidget {
  UserState({super.key, required super.child});

  late int userId;
  String rootURL = "141.71.164.168:6060";
  late String bearerToken;
  late HTTPRequestBuilder builder = HTTPRequestBuilder(rootURL);


  static UserState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserState>();

  static UserState of(BuildContext context) {
    final UserState? result = maybeOf(context);
    assert(result != null, 'No UserState found in context');
    return result!;
  }


  void register({required String name, required String password}) async {
    String hashedPassword = password;
    var url = Uri.http(rootURL, "register");
    var response =
        await http.post(url, body: {"name": name, "password": hashedPassword});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void login({required String name, required String password}) async {
    //Todo password hash
    String hashedPassword = password;
    var url = Uri.http(rootURL, "login");
    print(url);
    var response =
        await http.post(url, body: {"name": name, "password": hashedPassword});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    bearerToken = jsonDecode(response.body)["token"];
  }

  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return rootURL != oldWidget.rootURL;
  }
}
