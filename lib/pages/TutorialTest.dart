import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../UserState.dart';
import '../state.dart';
import '../util/CameraNew.dart';
import '../util/HTTPRequestBuilder.dart';
import '../util/Popups.dart';
import 'AddCategory.dart';
import 'CategoryOverview.dart';
import 'Homepage.dart';
import 'Info.dart';
import 'Login.dart';

class TutorialTest extends StatefulWidget {
  const TutorialTest({Key? key}) : super(key: key);

  @override
  TutorialTestState createState() => TutorialTestState();
}

class TutorialTestState extends State<TutorialTest> {
  late TutorialCoachMark tutorialCoachMark;

  final Prop<int> _currentIndex = Prop(0);
  final List<String> _titleList = ["Home", "Categories"];
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  /// _title dependant on _currentIndex and well update on change
  late final ComputedProp<String> _title = ComputedProp(() => _titleList[_currentIndex.value], [_currentIndex]);
  final PageController _pageController = PageController(initialPage: 0);

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();

  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(title: $(
                _title, (String title) =>
                Text(title)), automaticallyImplyLeading: false),
            body: PageView(
              onPageChanged: (newIndex) {},
              children: [
                Homepage(context: context, foreignKey: keyButton),
                CategoryOverview(),
              ],
            ),
            floatingActionButton: $(
              _currentIndex, (p0) =>
                SpeedDial(
                  key: keyBottomNavigation3,
                  // ToDo: menu_close is not the perfect icon, but not as confusing as the add event icon
                  animatedIcon: AnimatedIcons.menu_close,
                  spaceBetweenChildren: 10,
                  openCloseDial: isDialOpen,
                  children: [
                    _currentIndex.value == 0 ? SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          createExpensePopup(context: context);
                          isDialOpen.value = false;
                        },
                      ),
                      label: "Add Expense",
                    ) : SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.category),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AddCategory()),);
                          isDialOpen.value = false;
                        },
                      ),
                      label: "Add Category",
                    ),
                    // TODO: remove this button when the app is finished
                    SpeedDialChild(
                        visible: false,
                        child: IconButton(
                          icon: const Icon(Icons.bug_report),
                          onPressed: () async {
                            UserState
                                .of(context)
                                .categoryList
                                .forEach((element) {
                              print(element.name);
                            });
                            isDialOpen.value = false;
                          },
                        ),
                        label: "DevelopmentButton"),
                    SpeedDialChild(
                        child: IconButton(
                          icon: const Icon(Icons.camera),
                          onPressed: () async {
                            final cameras = await availableCameras();
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => TakePictureScreen(
                                    camera: cameras.first)));
                            isDialOpen.value = false;
                          },
                        ),
                        label: "Open Camera"),
                  ],
                ),

            ),
            endDrawer: MenuDrawer(),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
            bottomNavigationBar: $(
                _currentIndex,
                    (int index) =>
                    BottomNavigationBar(
                      currentIndex: _currentIndex.value,
                      selectedItemColor: Colors.red,
                      unselectedItemColor: Colors.grey,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.euro_outlined, key: keyBottomNavigation1,),
                          label: "Expenses",
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.inventory_2_outlined, key: keyBottomNavigation2),
                            label: "Categories"),
                      ],
                      onTap: (newIndex) {
                        _pageController.animateToPage(newIndex,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                        _currentIndex.value = newIndex;
                      },
                    )
            )
        )
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
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

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Expense Tab",
        keyTarget: keyBottomNavigation1,
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
        identify: "Category Tab",
        keyTarget: keyBottomNavigation2,
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
        identify: "SpeedDial",
        keyTarget: keyBottomNavigation3,
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
      identify: "ExpenseOverview",
      keyTarget: keyButton,
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
}

class MenuDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Prop<bool> _loginState = Prop(HTTPRequestBuilder().loggedIn);
    return Drawer(
        width: 250,
        child: ListView(children: [
          const Icon(Icons.account_circle_outlined, size: 100),
          $(_loginState, (p0) => _loginState.value
              ? ListTile(
              title: Text(HTTPRequestBuilder().username[0].toUpperCase() + HTTPRequestBuilder().username.substring(1), textAlign: TextAlign.center),
              subtitle: const Text('', textAlign: TextAlign.center))
              : const ListTile(
              title: Text('Hey!', textAlign: TextAlign.center),
              subtitle: Text('', textAlign: TextAlign.center)),
          ),
          $(_loginState, (p0) => _loginState.value
              ? ElevatedButton(
              onPressed: () async {
                //Navigate to the Login-Screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: 'Login')),);
                UserState.of(context).logoutUser();
              },
              style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 40),
                  Icon(Icons.login_outlined, size: 24.0),
                  SizedBox(width: 10),
                  Text("Logout"),
                ],
              )
          )
              :ElevatedButton(
              onPressed: () async {
                // Close drawer due to catch name and email from logged in user on successful login
                Navigator.pop(context);
                //Navigate to the Login-Screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: 'Login')));
                //UserState.of(context).loginUser(name: "erik", password: "test");

              },
              style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 40),
                  Icon(Icons.login_outlined, size: 24.0),
                  SizedBox(width: 10),
                  Text("Login"),
                ],
              )
          )
          ),
          ElevatedButton(
            onPressed: () {},//=> colorPicker(currentColor: MyApp.of(context)._themeColor, currentThemeMode: MyApp.of(context)._themeMode, context: context),
            style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                Icon(Icons.design_services_outlined, size: 24.0),
                SizedBox(width: 10),
                Text('Theme Settings'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Info(title: 'Info'))),
            style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                Icon(Icons.info_outlined, size: 24.0),
                SizedBox(width: 10),
                Text('Info Screen'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialTest())),
            style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                Icon(Icons.departure_board, size: 24.0),
                SizedBox(width: 10),
                Text('Tutorial Test'),
              ],
            ),
          ),
        ],
        )
    );
  }
}