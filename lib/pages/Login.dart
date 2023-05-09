import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../UserState.dart';
import '../util/HTTPRequestBuilder.dart';
import '../util/Popups.dart';

class Login extends StatelessWidget {
  Login({super.key, required this.title});

  final String title;

  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text("Log in to your MoneyMate",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20)
                    )
                  ),
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
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await UserState.of(context).loginUser(name: 'erik', password: 'test');
                          //await UserState.of(context).loginUser(name: usernameController.value.text, password: passwordController.value.text); //todo - use this
                          if(context.mounted) {
                            UserState.of(context).initListExpenseList();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logged in!')),);
                            Navigator.pop(context); // Navigate the user to the Home page
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Have no Account?', textAlign: TextAlign.center),
                  GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registering...'))), //todo - change login page to registerPage onTap
                        child: Text('Register instead', textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline)),
                  ),
                  SizedBox(height: 90),
                  Column(
                    children: <Widget>[
                      Text("Additional Information", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
                      Divider(),
                      ListTile(
                        title: Text('What is MoneyMate?'),
                        subtitle: Text('MoneyMate helps you keep track of your finances'),
                      ),
                      ListTile(
                        title: Text('Version Info'),
                        subtitle: Text('Beta 0.1'),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
              ]),
          )
        )
    );
  }
}