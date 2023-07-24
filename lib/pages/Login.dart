import 'package:flutter/material.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
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
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  //todo - upon login the dashboard is not refreshed, so that required information is missing, until another page is opened and closed
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("staySignedIn") ?? false) {
        _usernameController.text = prefs.getString("username") ?? "";
        _passwordController.text = prefs.getString("password") ?? "";
        await UserState.of(context).loginUser(name: _usernameController.text, password: _passwordController.text);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Hud()
            )
        );
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
                    new Image.asset('images/icon.png', height: 100, width: 100),
                    const SizedBox(height: 30),
                    Center(
                        child: Text("Log in to your MoneyMate",
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20))),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Username"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Username';
                        }
                        return null;
                      },
                      onFieldSubmitted: (text) => _fieldFocusChange(context, _usernameFocus, _passwordFocus),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onFieldSubmitted: (text) => submitButtonClick(),
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
                          submitButtonClick();
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Have no Account?', textAlign: TextAlign.center),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(title: 'Register')),
                      ),
                      child: Text('Register instead',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                    ),
                    SizedBox(height: 160),
                    ListTile(
                      title: Text('Version Info', textAlign: TextAlign.center),
                      subtitle: Text('Beta 0.1', textAlign: TextAlign.center),
                    ),
                  ]),
                )
            )
        )
    );
  }

  Future<void> submitButtonClick() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      await UserState.of(context).loginUser(
          name: _usernameController.value.text,
          password: _passwordController.value.text);
      HTTPRequestBuilder builder = HTTPRequestBuilder();

      if (builder.loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
            uniformSnackBar('Logged in!')
        );

        if (staySignedIn) {
          await prefs.setBool("staySignedIn", true);
          await prefs.setString("username", _usernameController.value.text);
          await prefs.setString("password", _passwordController.value.text);
        } else {
          await prefs.setBool("staySignedIn", false);
          await prefs.setString("username", "");
          await prefs.setString("password", "");
        }

        if(context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Hud()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            uniformSnackBar('Incorrect credentials')
        );
      }
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
