
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/pages/CategoryOverview.dart';
import 'package:money_mate/pages/AddCategory.dart';
import 'package:money_mate/pages/Homepage.dart';
import 'package:money_mate/pages/Info.dart';
import 'package:money_mate/pages/Login.dart';
import 'package:money_mate/pages/TutorialTest.dart';
import 'package:money_mate/pages/TutorialTest2.dart';
import 'package:money_mate/state.dart';
import 'package:money_mate/util/CameraNew.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'UserState.dart';

Future<void> mainTest() async {
  //Initialize for Camera
  WidgetsFlutterBinding.ensureInitialized();

  //await dotenv.load(fileName: '.env');
  Intl.defaultLocale = 'pt_BR';
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
  }

  // This widget is the root of your application.
  class _MyAppState extends State<MyApp> {
    late TutorialCoachMark tutorialCoachMark;

    ThemeMode _themeMode = ThemeMode.system;
    Color _themeColor = Color(0xff6750a4);
    Widget _startWidget = Login(title: 'Login');

    List<GlobalKey> _keyList = List.generate(5, (index) => GlobalKey()); //keyList for referencing widgets shown in the tutorial

    //static final TutorialTest2 _instance = TutorialTest2().getInstance();

    @override
    void initState() {
      //todo - load app settings on initialization
      /*
      if(user !logged in) => showTutorial();
       */

      //only for testing
      if(true) {
        _startWidget = Hud();
        createTutorial(_keyList);
        Future.delayed(Duration.zero, showTutorial(context));
      }

      /* for test2
      //todo - fix ?
      _instance.createTutorial(_keyList);
      Future.delayed(Duration(seconds: 5), _instance.showTutorial(context));

       */
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return UserState(child: MaterialApp(
      title: 'Money Mate',
      theme: ThemeData(
        colorSchemeSeed: _themeColor, useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: _themeColor, brightness: Brightness.dark, useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: _startWidget,
    ));
  }
  //used to change between light/dark/system mode
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
  //used to change themeColor //todo - figure out how to create a whole color palette instead of using a color as a seed
  void changeThemeColor(Color color) {
    setState(() {
      _themeColor = color;
    });
  }

    showTutorial(context) {
      tutorialCoachMark.show(context: context);
    }

    void createTutorial(List<GlobalKey> keyList) {
      tutorialCoachMark = TutorialCoachMark(
        targets: _createTargets(keyList),
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

    List<TargetFocus> _createTargets(List<GlobalKey> keyList) {
      List<TargetFocus> targets = [];
      targets.add(
        TargetFocus(
          identify: "Expense Tab",
          keyTarget: keyList[0],
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
          keyTarget: keyList[1],
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
          keyTarget: keyList[2],
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
        keyTarget: keyList[3],
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

class Hud extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HudState();
  Hud({super.key});
}

class HudState extends State<Hud> {
  final Prop<int> _currentIndex = Prop(0);
  final List<String> _titleList = ["Home", "Categories"];
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  /// _title dependant on _currentIndex and well update on change
  late final ComputedProp<String> _title = ComputedProp(() => _titleList[_currentIndex.value], [_currentIndex]);
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(title: $(_title, (String title) => Text(title)), automaticallyImplyLeading: false),
            body: PageView(
              controller: _pageController,
              onPageChanged: (newIndex) {
                _currentIndex.value = newIndex;
              },
              children:[
                Homepage(context: context/*, foreignKey: MyApp.of(context)._keyList[3]*/),
                const CategoryOverview(),
              ],
            ),
            floatingActionButton: $(
              _currentIndex, (p0) => SpeedDial(
                // ToDo: menu_close is not the perfect icon, but not as confusing as the add event icon
                key: MyApp.of(context)._keyList[2],
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory()),);
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
                          UserState.of(context).categoryList.forEach((element) {print(element.name);});
                          isDialOpen.value = false;
                        },
                      ),
                      label: "DevelopmentButton"),
                  SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.camera),
                        onPressed: ()  async {
                          final cameras = await availableCameras();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: cameras.first)));
                          isDialOpen.value = false;
                        },
                      ),
                      label: "Open Camera"),
                  /*SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.category),
                        onPressed: ()  {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory()),);
                          isDialOpen.value = false;
                        },
                      ),
                      label: "Add Category"),*/
                 /* SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.local_grocery_store),
                        onPressed: ()  {
                          UserState.of(context).addCategory(name: "nameTestLol2", budget: 100);
                        },
                      ),
                      label: "Test"),*/
                ],
              ),

            ),
            endDrawer: MenuDrawer(),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
            /// BottomNavigation bar will be rebuild when _currentIndex get changed
            bottomNavigationBar: $(
                _currentIndex,
                (int index) => BottomNavigationBar(
                      currentIndex: _currentIndex.value,
                      selectedItemColor: MyApp.of(context)._themeColor,
                      unselectedItemColor: Colors.grey,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.euro_outlined, key: MyApp.of(context)._keyList[0]),
                          label: "Expenses",
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.inventory_2_outlined, key: MyApp.of(context)._keyList[1]),
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
            onPressed: () => colorPicker(currentColor: MyApp.of(context)._themeColor, currentThemeMode: MyApp.of(context)._themeMode, context: context),
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

