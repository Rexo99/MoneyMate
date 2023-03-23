import 'dart:convert';

import 'package:cash_crab/state.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
//Todo Pit fragen
import 'package:pointycastle/asymmetric/api.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:cash_crab/util/HTTPRequestBuilder.dart';
import 'package:flutter/cupertino.dart';

import 'models/models.dart';

class UserState extends InheritedWidget {
  UserState({super.key, required super.child});

  late final int userId;
  final String rootURL = "192.168.0.136:6060";
  late final String bearerToken;
  late final HTTPRequestBuilder builder = HTTPRequestBuilder(rootURL);


  Prop<IList<Prop<Category>>> categoryList = Prop(<Prop<Category>>[].lockUnsafe);
  Prop<IList<Prop<Expenditure>>> expendList = Prop(<Prop<Expenditure>>[].lockUnsafe);




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
    print(bearerToken);
  }

  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return rootURL != oldWidget.rootURL;
  }

  Future<String> encode({required password}) async {
    //Todo finde a way to get access from phone

    final publicKey = await parseKeyFromFile<RSAPublicKey>('test/certs/public.pem');
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    return encrypter.encrypt(password).base64;
  }
}





