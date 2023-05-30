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
                        onTap: () => infoPopup(featureList: [Text('Info Page \n''Login Page', textAlign: TextAlign.center), /*todo fill list*/], context: context),
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
                    title: Text('Widget 1'),
                    subtitle: Text('Used for XXX'),
                  ),
                  ListTile(
                    title: Text('Widget 2'),
                    subtitle: Text('Used for XXX'),
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
                    title: Text('Package 2'),
                    subtitle: Text('Used for XXX'),
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
