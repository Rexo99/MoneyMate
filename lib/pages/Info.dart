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
              Text("The MoneyMate team:",
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20)
              ),
              const SizedBox(height: 20),
                Row(children: [
                  Flexible(child:
                    Column(children: [
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [Text('', textAlign: TextAlign.center), /*todo fill list*/], context: context),
                        child: Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      ListTile(
                        title: Text('Daniel Ottolien', textAlign: TextAlign.center),
                        subtitle: Text('1629292', textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [Text('Info Page \n Login Page View \n Tutorial \n Adjustable App Theme' , textAlign: TextAlign.center), /*todo fill list*/], context: context),
                        child: Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      ListTile(
                        title: Text('Dorian Zimmermann', textAlign: TextAlign.center),
                        subtitle: Text('1671737', textAlign: TextAlign.center)
                      ),
                    ],),
                  ),
                  Expanded(child:
                    Column(children: [
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [Text('', textAlign: TextAlign.center), /*todo fill list*/], context: context),
                        child: Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      ListTile(
                          title: Text('Dannie Krösche', textAlign: TextAlign.center),
                          subtitle: Text('1629522', textAlign: TextAlign.center)
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => infoPopup(featureList: [Text('', textAlign: TextAlign.center), /*todo fill list*/], context: context),
                        child: Icon(Icons.account_circle_outlined, size: 90),
                      ),
                      ListTile(
                          title: Text('Erik Hinkelmanns', textAlign: TextAlign.center),
                          subtitle: Text('1583861', textAlign: TextAlign.center)
                      ),
                    ],),
                  ),
                ]),
              const SizedBox(height: 30),
              ExpansionTile(
                title: Text("Used Widgets"),
                children: <Widget>[
                  ListTile(
                    title: Text('Expansion Tile'),
                    subtitle: Text("Tile that can be opened and closed to show and hide it's content"),
                  ),
                  ListTile(
                    title: Text('List Tile'),
                    subtitle: Text('Tile for displaying text. Useful because of title and subtitle attributes'),
                  ),
                  ListTile(
                    title: Text('Toggle Buttons'),
                    subtitle: Text('An arrangement of buttons that highlight the currently selected button'),
                  ),
                  ListTile(
                    title: Text('Divider'),
                    subtitle: Text('Draws a horizontal line across the screen'),
                  ),
                  ListTile(
                    title: Text('Widget'),
                    subtitle: Text('Used for'),
                  )
                ],
              ),
              ExpansionTile(
                title: Text('Used Flutter-Packages'),
                children: <Widget>[
                  ListTile(
                    title: Text('Flutter Launcher Icons'),
                    subtitle: Text('Used for generating and setting App-Icons'),
                  ),
                  ListTile(
                    title: Text('Shared preferences plugin'),
                    subtitle: Text('Used for saving user data'),
                  ),
                  ListTile(
                    title: Text('TutorialCoachMark plugin'),
                    subtitle: Text('Used for creating and displaying the Tutorial'),
                  )
                ],
              ),
              ExpansionTile(
                title: Text('Copyright'),
                children: <Widget>[
                  ListTile(
                    title: Text('App Icon'),
                    subtitle: Text('Euro icons created by Smashicons - Flaticon'),
                  ),
                  ListTile(
                    title: Text('Icon n'),
                    subtitle: Text('Name'),
                  )
                ],
              ),
            ],),
        )
    );
  }
}
