import 'package:flutter/material.dart';
import 'package:money_mate/main.dart';
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
  bool tapped = false;
  int currentTab = 1;

  void showTutorial(BuildContext context) {
    buildContext = context;
    finished = false;
    try {
      tutorialCoachMark.show(context: context);
    } catch (exception) {
      finished = true;
      print('Exception occurred while showing the tutorial');
      print(exception.toString()); //todo - remove line
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

        //tutorialCoachMark2.show(context: buildContext);
      },
      onClickTarget: (target) {
        print('onClickTarget: $target $currentTab');

        currentTab += 1;

        /* //todo - doesnt work
        if(currentTab == 2) {
          HudState().openSpeedDial(true);
          return;
        }

        if(currentTab == 3) {
          HudState().openSpeedDial(false);
          return;
        }
         */
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

    tutorialCoachMark2 = TutorialCoachMark(
      targets: _createTargets2(),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.0,
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

  //todo - save position of required widget in mains build() and reference them here? Alternatively hardcode tutorial locations for pixel 2 or try getting the usable screen margin
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
        identify: "HomeScreen",
        targetPosition: TargetPosition(Size.square(10), Offset(_screenWidth * 0.5, -20)),
        alignSkip: Alignment.topRight,
        paddingFocus: 0,
        radius: 0,
        color: Colors.black,
        focusAnimationDuration: Duration(milliseconds: 5),
        unFocusAnimationDuration: Duration(milliseconds: 1),
        enableTargetTab: false,
        enableOverlayTab: false,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 160),
                  Text("This is your \n Home screen",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 38
                      ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: 35),
                  Text("Your most recent Expenses \n are listed here \n \n From here you can navigate the app.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(onPressed: () => tutorialCoachMark.next(), child: Text('Understood')),
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
        //keyTarget: keys[2],
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
        identify: "Expense Tab",
        //keyTarget: keys[0],
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
                  Text("Expenses tab",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                  ),
                  Text('Here you can view your most recent expenses, as well as your daily and monthly spendings',
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
                children: const <Widget>[
                  Text("Categories tab",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                  ),
                  Text('Here you can view all of your categories',
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
      identify: "See All",
      //keyTarget: keys[3],
      targetPosition: TargetPosition(Size.square(40), Offset(_screenWidth * 0.45, _screenHeight * 0.485)), //values perfect for pixel 2
      alignSkip: Alignment.topRight,
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
                  "Expenses",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 35.0
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Click here to see a list of all your expenses.",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
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
                SizedBox(height: 125),
                Text(
                  "Drawer",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 35.0
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Tap this icon to open a drawer, \n from where you can logout, \n change how the app looks \n and more.",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    ));
    return targets;
  }

  List<TargetFocus> _createTargets2() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Introduction",
        targetPosition: TargetPosition(
            Size.square(.01), Offset(_screenWidth * 0.5, -10)),
        alignSkip: Alignment.topRight,
        paddingFocus: 0,
        radius: 0,
        color: Colors.black,
        focusAnimationDuration: Duration(milliseconds: 1),
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
                  AlertDialog(
                    content: Column(children: [
                      Text("This is your Home screen. \n Your most recent Expenses are listed here \n From here you can navigate the app.",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40
                          ),
                          textAlign: TextAlign.center
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(onPressed: () => tutorialCoachMark.next(),
                          child: Text('Understood')),
                    ],) ,
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
    // TODO: implement build
    throw UnimplementedError();
  }
}