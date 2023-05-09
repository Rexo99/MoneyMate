import 'package:flutter/material.dart';
import '../util/Popups.dart';

class Login extends StatelessWidget {
  Login({super.key, required this.title});

  final String title;

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
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
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your E-Mail';
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Navigate the user to the Home page
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  SizedBox(height: 110),
                  ExpansionTile(
                    title: Text("Additional Information"),
                    children: <Widget>[
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