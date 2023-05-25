import 'package:flutter/material.dart';
import '../UserState.dart';
import '../main.dart';
import 'Login.dart';

class Register extends StatelessWidget {
  Register({super.key, required this.title});

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
                          child: Text("Register for MoneyMate",
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
                              return 'Please choose a Username';
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
                              return 'Please enter a safe password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await UserState.of(context).registerUser(name: usernameController.value.text, password: passwordController.value.text);
                                if(context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registered!')),);
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
                        Text('Already have an Account?', textAlign: TextAlign.center),
                        GestureDetector(
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Login(title: 'Login')),),
                              child: Text('Log in instead', textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline)),
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
                        ElevatedButton(onPressed:() => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => UserState(child: Hud())),),
                            child: Text('Debug exit')), //todo - remove debug button
                        SizedBox(height: 30),
                    ]),
                )
              )
          )
    );
  }
}