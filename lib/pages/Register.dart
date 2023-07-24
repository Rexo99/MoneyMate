import 'package:flutter/material.dart';
import 'package:money_mate/util/Popups.dart';
import '../UserState.dart';
import '../main.dart';
import 'Login.dart';

class Register extends StatelessWidget {
  Register({super.key, required this.title});

  final String title;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

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
                          controller: _usernameController,
                          focusNode: _usernameFocus,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Username"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose a Username';
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
                              return 'Please enter a safe password';
                            }
                            return null;
                          },
                          onFieldSubmitted: (text) => submitButtonClick(context),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              submitButtonClick(context);
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

                    ]),
                )
            )
        )
    );
  }

  Future<void> submitButtonClick(context) async {
    if (_formKey.currentState!.validate()) {
      if(await UserState.of(context).registerUser(name: _usernameController.value.text, password: _passwordController.value.text) == false) {
        ScaffoldMessenger.of(context).showSnackBar(
        uniformSnackBar('This username is already taken.')
        );
      } else {
        await UserState.of(context).loginUser(name: _usernameController.value.text, password: _passwordController.value.text);

        //Todo spaghetti code, move generating default data to backend
        await UserState.of(context).addCategory(name: 'Lebensmittel', budget: 400, icon: 'local_grocery_store');
        await UserState.of(context).initListCategoryList();
        UserState.of(context).expendList.addExpense(name: 'Mensa-Guthaben', amount: 20, categoryId: UserState.of(context).categoryList[0].id!);

        if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        uniformSnackBar('Registered!'));

        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => Hud()));// Navigate the user to the Home page
        }
      }
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
      uniformSnackBar('Please fill input fields')
    );
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
