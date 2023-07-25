import 'package:flutter/material.dart';
import 'package:money_mate/util/Popups.dart';
import '../UserState.dart';
import '../main.dart';
import 'Login.dart';

/// Register Page, opened from [Login.dart] if the user has no account yet.
/// The user enters their credentials in the two [TextFormField]s
/// User is forwarded to the [Homepage] / [Hud] upon successful registering.
///
/// Code in [Login.dart] by Erik Hinkelmanns, Dannie Krösche (Processing user data and login)
/// and Dorian Zimmermann (Page Composition, Widgets and User-Feedback)
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
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ListView(
                      children: [
                        SizedBox(height: screenHeight / 13),
                        Center(
                            child: Text("Register for MoneyMate",
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20)
                            )
                        ),
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
                              return 'Please choose a Username';
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
                              return 'Please enter a safe password';
                            }
                            return null;
                          },
                          onFieldSubmitted: (text) => submitButtonClick(context),
                        ),
                        SizedBox(height: screenHeight / 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              submitButtonClick(context);
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                        SizedBox(height: screenHeight / 15),
                        Text('Already have an Account?', textAlign: TextAlign.center),
                        SizedBox(height: screenHeight / 70),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Login(title: 'Login')),),
                          child: Text('Log in instead', textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline)),
                        ),
                        SizedBox(height: screenHeight / 6),
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

  /// Changes focus to the next [TextFormField]
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
