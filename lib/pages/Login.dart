import 'package:flutter/material.dart';
import 'package:money_mate/pages/Homepage.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UserState.dart';
import '../main.dart';
import 'Register.dart';

/// Login Page, loaded first when starting the app.
/// The user enters their credentials in the two [TextFormField]s
/// or clicks on the [Text] beneath to switch to [Register.dart].
/// If the user opens the app again and has [staySignedIn] activated,
/// they will be logged in automatically.
/// User is forwarded to the [Homepage] / [Hud] upon successful login.
///
/// Code in [Login.dart] by Erik Hinkelmanns, Dannie Krösche (Processing user data and login)
/// and Dorian Zimmermann (Page Composition, Widgets and User-Feedback)
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    /// Checks if the user activated [staySignedIn].
    /// If so, the user is logged in automatically
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("staySignedIn") ?? false) {
        _usernameController.text = prefs.getString("username") ?? "";
        _passwordController.text = prefs.getString("password") ?? "";
        await UserState.of(context).loginUser(name: _usernameController.text, password: _passwordController.text);

        Navigator.push(context,
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
                    SizedBox(height: screenHeight / 13),
                    Center(
                        child: Text("Log in to your MoneyMate",
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20))),
                    SizedBox(height: screenHeight / 15.5),
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
                    SizedBox(height: screenHeight / 52),
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
                    SizedBox(height: screenHeight / 52),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          submitButtonClick();
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                    SizedBox(height: screenHeight / 12),
                    Text('Have no Account?', textAlign: TextAlign.center),
                    SizedBox(height: screenHeight / 70),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(title: 'Register')),
                      ),
                      child: Text('Register instead',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(decoration: TextDecoration.underline, fontSize: 15)),
                    ),
                    SizedBox(height: screenHeight / 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Image.asset('images/icon.png', height: 100, width: 100),
                        Text("MoneyMate \n Your helper in finance", textAlign: TextAlign.center,)
                      ],
                    )
                  ]),
                )
            )
        )
    );
  }

  /// Checks the entered user data after clicking the [SubmitButton],
  /// and logs the user in
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

  /// Changes focus to the next [TextFormField]
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
