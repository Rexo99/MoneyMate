import 'package:flutter/material.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UserState.dart';
import '../main.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  Login({super.key, required this.title});

  final String title;

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool staySignedIn = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //todo - upon login the dashboard is not refreshed, so that required information is missing, until another page is opened and closed
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("staySignedIn") ?? false) {
        usernameController.text = prefs.getString("username") ?? "";
        passwordController.text = prefs.getString("password") ?? "";
        await UserState.of(context).loginUser(name: usernameController.text, password: passwordController.text);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Hud()));
      }
    });

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ListView(children: [
                    const SizedBox(height: 100),
                    Center(
                        child: Text("Log in to your MoneyMate",
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20))),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Username"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            value: staySignedIn,
                            onChanged: (bool? value) {
                              setState(() {
                                staySignedIn = value!;
                              });
                            },
                          ),
                          Text('Stay signed in?')
                        ]),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          if (_formKey.currentState!.validate()) {
                            await UserState.of(context).loginUser(
                                name: usernameController.value.text,
                                password: passwordController.value.text);
                            HTTPRequestBuilder builder = HTTPRequestBuilder();

                            if (builder.loggedIn) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged in!')),
                              );

                              if (staySignedIn) {
                                await prefs.setBool("staySignedIn", true);
                                await prefs.setString("username", usernameController.value.text);
                                await prefs.setString("password", passwordController.value.text);
                              } else {
                                await prefs.setBool("staySignedIn", false);
                                await prefs.setString("username", "");
                                await prefs.setString("password", "");
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Hud()));
                            }
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Have no Account?', textAlign: TextAlign.center),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(title: 'Register')),
                      ),
                      child: Text('Register instead',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                    ),
                    SizedBox(height: 200),
                    Column(
                      children: <Widget>[
                        Divider(),
                        ListTile(
                          title: Text('Version Info'),
                          subtitle: Text('Beta 0.1'),
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Hud()),
                            ),
                        child: Text('Debug exit')), //todo - remove debug button
                  ]),
                ))));
  }
}
