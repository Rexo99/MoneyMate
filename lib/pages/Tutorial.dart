import 'package:flutter/material.dart';
import 'package:money_mate/util/Popups.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Used to create and show the tutorial when first starting the app.
///
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
      ScaffoldMessenger.of(context).showSnackBar(uniformSnackBar("Tutorial failed. Please try again."));
    }
  }

  void createTutorial() {
    _screenWidth = WidgetsBinding.instance.renderView.size.width;
    _screenHeight = WidgetsBinding.instance.renderView.size.height;

    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      textSkip: "SKIP",
      opacityShadow: 0.9,
      showSkipInLastTarget: false,
      onFinish: () {
        finished = true;
      },
      onSkip: () {
        finished = true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Introduction",
        targetPosition: TargetPosition(Size.square(.01), Offset(_screenWidth * 0.5, -60)),
        alignSkip: Alignment.topRight,
        paddingFocus: 50,
        radius: 0,
        focusAnimationDuration: Duration(milliseconds: 1),
        unFocusAnimationDuration: Duration(milliseconds: 700),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: _screenHeight / 5),
                  const Text("Welcome to MoneyMate!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40
                    ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: _screenHeight / 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Image.asset('images/icon.png', height: _screenHeight / 9.7, width: _screenHeight / 9.7),
                      const Text("Your helper in finance", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20))
                    ],
                  ),
                  SizedBox(height: _screenHeight / 9.7),
                  const Text("Here's a quick rundown of what you can do with this App",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _screenHeight / 9.7),
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
                children: <Widget>[
                  const Text("This is the \n Expense tab",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _screenHeight / 31),
                  const Text('Here you can view ...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _screenHeight / 25.86),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Your most recent expenses",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.refresh, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: _screenHeight / 51.72),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Daily and monthly spendings",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.calendar_today, size: 30, color: Colors.white)
                    ],),
                  SizedBox(height: _screenHeight / 15.51),
                  const Text("Click 'See All' to view all expenses",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _screenHeight / 3.88)
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Add Button",
        targetPosition: TargetPosition(Size.square(25), Offset(_screenWidth * 0.470, _screenHeight * 0.897)), //values perfect for pixel 2
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Add Button",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 35.0),
                  ),
                  SizedBox(height: _screenHeight / 25.86),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Conveniently add: ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: _screenHeight / 31.03),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "New Expenses",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.euro, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: _screenHeight / 38.79),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "New Categories",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.inventory_2_outlined, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: _screenHeight / 7.76),
                  const Text(
                    "What the button does depends \n on the tab you're on",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _screenHeight / 5.54),
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
                  const Text("Categories tab",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                  ),
                  SizedBox(height: _screenHeight / 25.86),
                  const Text('Here you can view your',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Categories  ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.inventory_2_outlined, size: 32, color: Colors.white)
                    ],),
                  SizedBox(height: _screenHeight / 31.03),
                  const Text('Click on a category to view \n all expenses of that category',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _screenHeight / 3.1)
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
              children: <Widget>[
                SizedBox(height: _screenHeight / 6.2),
                const Text(
                  "Statistics",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 35.0
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Tap here to see detailed \n usage statistics. \n \n Statistics include:",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: _screenHeight / 38.79),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your used budget \n per category",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.euro, size: 32, color: Colors.white)
                  ],),
                SizedBox(height: _screenHeight / 38.79),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "What you spent your \n money on the most",
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
              children: <Widget>[
                SizedBox(height: _screenHeight / 7.76),
                const Text(
                  "Menu",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 35.0
                  ),
                ),
                SizedBox(height: _screenHeight / 31.03),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Tap here to access the menu \n \n \n From here you can...",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: _screenHeight / 38.79),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Log out of MoneyMate",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.account_circle_outlined, size: 32, color: Colors.white)
                  ],),
                SizedBox(height: _screenHeight / 51.72),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Change your theme",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.design_services_outlined, size: 32, color: Colors.white)
                  ],),
                SizedBox(height: _screenHeight / 51.72),
                const Row(
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
        targetPosition: TargetPosition(Size.square(.01), Offset(_screenWidth * 0.5, -60)),
        paddingFocus: 50,
        radius: 0,
        focusAnimationDuration: Duration(milliseconds: 1),
        unFocusAnimationDuration: Duration(milliseconds: 700),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: _screenHeight / 4.5),
                  const Text("Have fun using MoneyMate",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40
                      ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: _screenHeight / 15.51),
                  const Text(
                    "We hope you like the App",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _screenHeight / 15.51),
                  ElevatedButton(onPressed: () => tutorialCoachMark.next(), child: Text('Sure!')),
                  SizedBox(height: _screenHeight / 4.31),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Image.asset('images/icon.png', height: 80, width: 80),
                      const Text("Your helper in finance", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20))
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