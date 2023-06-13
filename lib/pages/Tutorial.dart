import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../main.dart';
import 'Login.dart';

class Tutorial {
  late TutorialCoachMark tutorialCoachMark;
  late final double _screenWidth;
  late final double _screenHeight;
  bool finished = false;

  void showTutorial(BuildContext context) {
    finished = false;
    try {
      tutorialCoachMark.show(context: context);
      //showOverlay(context); //todo - delete line
    } catch (exception) {
      finished = true;
      print('Exception occurred while showing the tutorial');
      print(exception.toString()); //todo - remove line
    }
  }

  void createTutorial(List<GlobalKey> keys, context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    print(_screenWidth);
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(keys),
      colorShadow: Colors.black12,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
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
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets(List<GlobalKey> keys) {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Introduction",
        targetPosition: TargetPosition(Size.square(.01), Offset(_screenWidth * 0.5, -10)),
        alignSkip: Alignment.topRight,
        paddingFocus: 0,
        radius: 0,
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
                  Text("Welcome to MoneyMate!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40
                    ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: 35),
                  Text("Here's a quick rundown of what you can do with this App",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
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
        identify: "SpeedDial",
        //keyTarget: keys[2],
        targetPosition: TargetPosition(Size.square(25), Offset(_screenWidth * 0.473, _screenHeight * 0.89)),
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
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Conveniently add new expenses or categories here",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
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
        identify: "Expense Tab",
        //keyTarget: keys[0],
        targetPosition: TargetPosition(Size.square(10), Offset(_screenWidth * 0.239, _screenHeight * 0.94)),
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
        targetPosition: TargetPosition(Size.square(10), Offset(_screenWidth * 0.742, _screenHeight * 0.94)),
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
      targetPosition: TargetPosition(Size.square(40), Offset(_screenWidth * 0.45, _screenHeight * 0.455)),
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
        targetPosition: TargetPosition(Size.square(30), Offset(_screenWidth * 0.906, 38)),
      //targetPosition: TargetPosition(Size.square(30), Offset(372, 38)),
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

/* todo - delete block
  ///The Overlay is used to exit the 'demo mode' that mimics an existing account, so that new users can try out the app, before creating an own account
  void showOverlay(context) {
    OverlayEntry? entry;
    entry = OverlayEntry(builder: (context) => Positioned(
        left: 10, top: 100,
        child: ElevatedButton.icon(icon: Icon(Icons.exit_to_app), label: Text('End \n Demo', textAlign: TextAlign.center,),
          onPressed: () {
            removeOverlay(entry!);
            //todo - assumption that tutorials can only be started automatically, when the user is not yet registered/logged in
            Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: 'Login')),);
          },
        )
      )
    );

    final overlay = Overlay.of(context);
    overlay.insert(entry);
  }

  void removeOverlay(OverlayEntry entry) {
    entry.remove();
  }
   */
}