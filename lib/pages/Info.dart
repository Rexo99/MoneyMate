import 'package:flutter/material.dart';
import '../util/Popups.dart';

class Info extends StatelessWidget {
  Info({super.key, required this.title});

  final String title;


@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text("The MoneyMate team:",
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20)
              ),
              const SizedBox(height: 20),
                Row(children: [
                  Flexible(child:
                    Column(children: [
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [const Text('Category Overview \n Add Category Screen \n Edit Category Screen \n Popups(DeleteCategory)', textAlign: TextAlign.center), /*todo fill list*/], context: context),
                        child: const Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      const ListTile(
                        title: Text('Daniel Ottolien', textAlign: TextAlign.center),
                        subtitle: Text('1629292', textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [const Text('Info Page \n Login Page View \n Tutorial \n Adjustable App Theme' , textAlign: TextAlign.center), /*todo fill list*/], context: context),
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
                        onTap: () => infoPopup(featureList: [const Text('Category (business logic) \n App icons \n Login/register assistance (stay signed in, auto-login, login/register facade) \n Expense assistance (sorting, decimal) \n Backend assistance (error handling) \n Quality assurance (fine-tuning, testing, debugging)', textAlign: TextAlign.center)], context: context), /*todo fill list*/
                        child: const Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      const ListTile(
                          title: Text('Dannie Krösche', textAlign: TextAlign.center),
                          subtitle: Text('1629522', textAlign: TextAlign.center)
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [const Text('HUD \n Homepage \n ExpenseOverview \n models(expense) \n dtos(expense) \n Popups(ExpensePop) \n DateTimeExtensions \n HTTPRequestBuilder \n UserState', textAlign: TextAlign.center), /*todo fill list*/], context: context),
                        child: const Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      const ListTile(
                          title: Text('Erik Hinkelmanns', textAlign: TextAlign.center),
                          subtitle: Text('1583861', textAlign: TextAlign.center)
                      ),
                    ],),
                  ),
                ]),
              const SizedBox(height: 30),
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
                    title: Text('Widget', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for'),
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
                    title: Text('flutter_speed_dial', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for creating a collapsable menu on for  the floatingActionButton widget'),
                  ),
                  ListTile(
                    title: Text('flutter_swipe_action_cell', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Used for creating the slide menu for each expense in your list'),
                  )
                ],
              ),
              const ExpansionTile(
                title: Text('Copyright'),
                children: <Widget>[
                  ListTile(
                    title: Text('App Icon', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Euro icons created by Smashicons - Flaticon'),
                  ),
                  ListTile(
                    title: Text('Icon n', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Name'),
                  )
                ],
              ),
            ],),
        )
    );
  }
}
