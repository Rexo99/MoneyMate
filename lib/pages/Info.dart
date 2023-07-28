import 'package:flutter/material.dart';
import '../util/Popups.dart';

/// Info Page, that displays all team members, their respective implemented features,
/// as well as many used widgets and all packages inside the app.
/// All Code in [Info.dart] by Dorian Zimmermann
class Info extends StatelessWidget {
  Info({super.key, required this.title});

  final String title;

@override
  Widget build(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            children: [
              SizedBox(height: screenHeight / 38),
              const Text("The MoneyMate Team:",
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20)
              ),
              SizedBox(height: screenHeight / 38),
                Row(children: [
                  Flexible(child:
                    Column(children: [
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [const Text('Category Overview \n Add Category Screen \n Edit Category Screen \n CatExpense Screen \n (Adjusted ExpenseOverview) \n ConnectivityChecker \n Popups(ConnectivityPopup) \n Charts Overview Screen' , textAlign: TextAlign.center)], context: context),
                        child: const Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      const ListTile(
                        title: Text('Daniel Ottolien', textAlign: TextAlign.center),
                        subtitle: Text('1629292', textAlign: TextAlign.center),
                      ),
                      SizedBox(height: screenHeight / 19),
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [const Text('App Tutorial \n Login/ Register Page \n Login/ Register Exception Handling \n HomePage (EndDrawer) \n Info Page \n  App Design \n Adjustable App Theme \n Camera Initialization' , textAlign: TextAlign.center)], context: context),
                        child: const Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      const ListTile(
                        title: Text('Dorian Zimmermann', textAlign: TextAlign.center),
                        subtitle: Text('1671737', textAlign: TextAlign.center)
                      ),
                    ],),
                  ),
                  Expanded(child:
                    Column(children: [
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [const Text('Category (business logic) \n App icons \n Login/register assistance (stay signed in, auto-login, login/register facade) \n Expense assistance (sorting, decimal) \n Backend assistance (error handling) \n Quality assurance (fine-tuning, testing, debugging) \n Image on expense', textAlign: TextAlign.center)], context: context),
                        child: const Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      const ListTile(
                          title: Text('Dannie Krösche', textAlign: TextAlign.center),
                          subtitle: Text('1629522', textAlign: TextAlign.center)
                      ),
                      SizedBox(height: screenHeight / 19),
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [const Text('HUD \n Homepage \n ExpenseOverview \n models(expense) \n dtos(expense) \n Popups(ExpensePop) \n DateTimeExtensions \n HTTPRequestBuilder \n UserState', textAlign: TextAlign.center)], context: context),
                        child: const Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      const ListTile(
                          title: Text('Erik Hinkelmanns', textAlign: TextAlign.center),
                          subtitle: Text('1583861', textAlign: TextAlign.center)
                      ),
                    ],),
                  ),
                ]),
              SizedBox(height: screenHeight / 25),
              const ExpansionTile(
                title: Text("Used Widgets"),
                children: <Widget>[
                  ListTile(
                    title: Text('Expansion Tile', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Tile that can be opened and closed to show and hide it's content"),
                  ),
                  ListTile(
                    title: Text('List Tile', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Tile for displaying text. Useful because of title and subtitle attributes'),
                  ),
                  ListTile(
                    title: Text('Toggle Buttons', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('An arrangement of buttons that highlight the currently selected button'),
                  ),
                  ListTile(
                    title: Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Draws a horizontal line across the screen'),
                  ),
                  ListTile(
                    title: Text('PieChart', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Displays data as sections of a circular graph'),
                  ),
                  ListTile(
                    title: Text('BarChart', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Displays a bar for each data point'),
                  ),
                  ListTile(
                    title: Text('WillPopScore', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Widget, that ignores the system back button for navigation'),
                  ),
                  ListTile(
                    title: Text('SnackBar', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Widget used for status information for the user'),
                  ),
                  ListTile(
                    title: Text('Floating Action Button', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Button with different positional presets'),
                  ),
                  ListTile(
                    title: Text('GestureDetector', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Widget, that detects gestures on the screen'),
                  )
                ],
              ),
              const ExpansionTile(
                title: Text('Used Flutter-Packages'),
                children: <Widget>[
                  ListTile(
                    title: Text('Flutter Launcher Icons', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for generating and setting App-Icons'),
                  ),
                  ListTile(
                    title: Text('Shared preferences', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for saving user data'),
                  ),
                  ListTile(
                    title: Text('TutorialCoachMark', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for creating and displaying the Tutorial'),
                  ),
                  ListTile(
                    title: Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used to access the devices camera and take photos with it'),
                  ),
                  ListTile(
                    title: Text('jwt_decoder', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for decoding the jwt_token and read protected Data from it'),
                  ),
                  ListTile(
                    title: Text('http', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for send https requests to the backend and read the responses'),
                  ),
                  ListTile(
                    title: Text('fast_immutable_collections', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for creating immutable lists'),
                  ),
                  ListTile(
                    title: Text('flutter_swipe_action_cell', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for creating the slide menu for each expense in your list'),
                  ),
                  ListTile(
                    title: Text('connectivity_plus', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for checking the network status of the current device'),
                  ),
                  ListTile(
                    title: Text('fl_chart', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for data visualization'),
                  ),
                  ListTile(
                    title: Text('file_picker', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Allows you to use the native file explorer to pick files.'),
                  )
                ],
              ),
              const ExpansionTile(
                title: Text('Copyright'),
                children: <Widget>[
                  ListTile(
                    title: Text('App Icon', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Euro icons created by Smashicons - Flaticon'),
                  )
                ],
              ),
            ],),
        )
    );
  }
}
