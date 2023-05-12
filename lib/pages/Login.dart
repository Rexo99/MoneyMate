import 'package:flutter/material.dart';
import '../UserState.dart';
import '../main.dart';
import 'Register.dart';

class Login extends StatelessWidget {
  Login({super.key, required this.title});

  final String title;

  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

@override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
          child: Scaffold(
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
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Register(title: 'Register')),),
                              child: Text('Register instead', textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline)),
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
                        ElevatedButton(onPressed:() => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => UserState(child: Hud())),),
                            child: Text('Debug exit')), //todo - remove debug button
                    ]),
                )
              )
          )
    );
  }
}