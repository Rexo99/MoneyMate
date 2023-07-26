import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Code by Dorian Zimmermann
class Tutorial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TutorialState();
}

class TutorialState extends State {
  late TutorialCoachMark tutorialCoachMark;
  late TutorialCoachMark tutorialCoachMark2;
  late double _screenWidth;
  late double _screenHeight;
  late var buildContext;
  bool finished = false;

  void showTutorial(BuildContext context) {
    buildContext = context;
    finished = false;
    try {
      tutorialCoachMark.show(context: context);
    } catch (exception) {
      finished = true;
      print('Exception occurred while showing the tutorial');
    }
  }

  void createTutorial(/*List<GlobalKey> keys*/) {
    //todo - remove following lines
    _screenWidth = WidgetsBinding.instance.renderView.size.width;
    _screenHeight = WidgetsBinding.instance.renderView.size.height;
    print(WidgetsBinding.instance.renderView.configuration);
    print(_screenWidth);
    print(_screenHeight);

    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(/*keys*/),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      showSkipInLastTarget: false,
      onFinish: () {
        finished = true;
        print("Tutorial finished");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        finished = true;
        print("skip");
      },
    );
  }

  //todo - add relative spacing for widgets
  List<TargetFocus> _createTargets(/*List<GlobalKey> keys*/) {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Introduction",
        targetPosition: TargetPosition(Size.square(.01), Offset(_screenWidth * 0.5, -10)),
        alignSkip: Alignment.topRight,
        paddingFocus: 0,
        radius: 0,
        color: Colors.black,
        focusAnimationDuration: Duration(milliseconds: 5),
        unFocusAnimationDuration: Duration(milliseconds: 1),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100),
                  Text("Welcome to MoneyMate!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40
                    ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Image.asset('images/icon.png', height: 80, width: 80),
                      Text("Your helper in finance", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20))
                    ],
                  ),
                  SizedBox(height: 80),
                  Text("Here's a quick rundown of what you can do with this App",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(onPressed: () => tutorialCoachMark.next(), child: Text('Continue')),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Expense Tab",
        targetPosition: TargetPosition(Size.square(10), Offset(_screenWidth * 0.239, _screenHeight * 0.948)), //values perfect for pixel 2
        alignSkip: Alignment.topRight,
        paddingFocus: 26,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text("This is the \n Expense tab",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Text('Here you can view ...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Your most recent expenses",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.refresh, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Daily and monthly spendings",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.calendar_today, size: 30, color: Colors.white)
                    ],),
                  SizedBox(height: 50),
                  Text("Click 'See All' to view all expenses",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 200)
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "SpeedDial",
        targetPosition: TargetPosition(Size.square(25), Offset(_screenWidth * 0.470, _screenHeight * 0.897)), //values perfect for pixel 2
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "SpeedDial",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 35.0),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Conveniently add: ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "New Expenses",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.euro, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "New Categories",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.inventory_2_outlined, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: 100),
                  Text(
                    "What the SpeedDial does depends \n on the tab you're on",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 140),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Category Tab",
        //keyTarget: keys[1],
        targetPosition: TargetPosition(Size.square(10), Offset(_screenWidth * 0.738, _screenHeight * 0.948)), //values perfect for pixel 2
        alignSkip: Alignment.topRight,
        paddingFocus: 26,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Categories tab",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('Here you can view your',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Categories  ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.inventory_2_outlined, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: 30),
                  Text('Click on a category to view \n all expenses of that category',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 250)
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(TargetFocus(
      identify: "Charts",
      targetPosition: TargetPosition(Size.square(30), Offset(_screenWidth * 0.906 - 50, 38)), //values perfect for pixel 2
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                SizedBox(height: 125),
                Text(
                  "Statistics",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 35.0
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Tap here to see detailed \n usage statistics. \n \n Statistics include:",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your leftover budget \n per category",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.euro, size: 32, color: Colors.white)
                  ],),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "How much you spent \n compared to last month",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.bar_chart, size: 32, color: Colors.white)
                  ],),
              ],
            );
          },
        ),
      ],
    ));
    targets.add(TargetFocus(
      identify: "MenuDrawer",
      targetPosition: TargetPosition(Size.square(30), Offset(_screenWidth * 0.906, 38)), //values perfect for pixel 2
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                SizedBox(height: 100),
                Text(
                  "Menu",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 35.0
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Tap here to access the menu \n \n \n From here you can...",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Log out of MoneyMate",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.account_circle_outlined, size: 32, color: Colors.white)
                  ],),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Change your theme",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.design_services_outlined, size: 32, color: Colors.white)
                  ],),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Access the Info screen \n or rewatch this tutorial",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.info_outlined, size: 32, color: Colors.white)
                  ],),
              ],
            );
          },
        ),
      ],
    ));
    targets.add(
      TargetFocus(
        identify: "Message",
        targetPosition: TargetPosition(Size.square(.01), Offset(_screenWidth * 0.5, -10)),
        alignSkip: Alignment.topRight,
        paddingFocus: 0,
        radius: 0,
        color: Colors.black,
        focusAnimationDuration: Duration(milliseconds: 5),
        unFocusAnimationDuration: Duration(milliseconds: 1),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 150),
                  Text("Have fun using MoneyMate",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40
                      ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: 50),
                  Text(
                    "We hope you like the App",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(onPressed: () => tutorialCoachMark.next(), child: Text('Sure!')),
                  SizedBox(height: 180),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Image.asset('images/icon.png', height: 80, width: 80),
                      Text("Your helper in finance", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20))
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}