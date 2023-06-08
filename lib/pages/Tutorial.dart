import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Tutorial {
  late TutorialCoachMark tutorialCoachMark;

  void showTutorial(BuildContext context) {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial(List<GlobalKey> keys) {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(keys),
      colorShadow: Colors.black12,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${
                tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
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
        identify: "test",
        keyTarget: keys[0],
        alignSkip: Alignment.topRight,
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
                  Text('Here you can view your expenses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),)
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "test2",
        keyTarget: keys[1],
        alignSkip: Alignment.topRight,
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
                  Text('Here you can view your categories',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),)
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "test3",
        keyTarget: keys[2],
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "SpeedDial",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 35.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Add new expenses etc. here.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(TargetFocus(
      identify: "test4",
      keyTarget: keys[3],
      shape: ShapeLightFocus.Circle,
      //radius: 50
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    ));
    targets.add(TargetFocus(
      identify: "test5",
      keyTarget: keys[4],
      shape: ShapeLightFocus.Circle,
      //radius: 50
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
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
                    style: TextStyle(color: Colors.white),
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

  void showOverlay(context/*, OverlayEntry entry*/) {
    OverlayEntry? entry;
    entry = OverlayEntry(builder: (context) => Positioned(
        left: 20, top: 40,
        child: ElevatedButton.icon(icon: Icon(Icons.ac_unit), label: Text('Test'),
          onPressed: () {
            removeOverlay(entry!);
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
}