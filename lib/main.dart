import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/pages/CategoryOverview.dart';
import 'package:money_mate/pages/AddCategory.dart';
import 'package:money_mate/pages/ChartsOverview.dart';
import 'package:money_mate/pages/Homepage.dart';
import 'package:money_mate/pages/Info.dart';
import 'package:money_mate/pages/Login.dart';
import 'package:money_mate/pages/Tutorial.dart';
import 'package:money_mate/util/StateManagement.dart';
import 'package:money_mate/util/Camera.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'UserState.dart';

Future<void> main() async {
  //Initialize for Camera
  WidgetsFlutterBinding.ensureInitialized();

  //await dotenv.load(fileName: '.env');
  Intl.defaultLocale = 'pt_BR';
  runApp(UserState(child: const MyApp()) );
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
    ///Default values for loading the app
    ThemeMode _themeMode = ThemeMode.system;
    Color _themeColor = Color(0xff6750a4);
    Widget _startPage = Login(title: 'Login');

    ///Tutorial related
    late final List<GlobalKey> _tutorialKeys; //todo - delete if no longer needed
    bool _loadTutorial = false;

    @override
    void initState() {
      _tutorialKeys = List.generate(5, (index) => new GlobalKey(debugLabel: 'Tutorial')); //todo - delete if no longer needed
      checkFirstSeen();
      checkTheme();
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      return MaterialApp(
        title: 'Money Mate',
        theme: ThemeData(
          colorSchemeSeed: _themeColor, useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: _themeColor,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        home: _startPage,
        debugShowCheckedModeBanner: false,
      );
    }

    ///Checks SharedPreferences whether the app is started for the first time after installing or not
    Future checkFirstSeen() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? _seen = (prefs.getBool('tutorialSeen'));

      if(_seen == null || _seen == false) {
        _loadTutorial = true;
        _startPage = Hud();
        await prefs.setBool('tutorialSeen', true);
      }
    }

    ///Checks SharedPreferences which theme should be applied
    Future<void> checkTheme() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int? themeMode = prefs.getInt('themeMode');
      if(themeMode != null) {
        setState(() {
          _themeMode = getThemeModes().elementAt(themeMode);
        });
      }

      int? themeColor = prefs.getInt('themeColor');
      if(themeColor != null) {
        setState(() {
          _themeColor = getThemeColors().elementAt(themeColor);
        });
      }
    }

    ThemeMode getCurrentThemeMode() {
      return _themeMode;
    }

    List<ThemeMode> getThemeModes() {
      return <ThemeMode> [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    }

    Future<void> changeTheme(Color color, ThemeMode themeMode) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('themeColor', getThemeColors().indexOf(color));
      prefs.setInt('themeMode', getThemeModes().indexOf(themeMode));
      setState(() {
        _themeColor = color;
        _themeMode = themeMode;
      });
    }

    Color getCurrentThemeColor() {
      return _themeColor;
    }

    ///Returns the list of available theme colors. Only stored here so they can be changed easily
    List<Color> getThemeColors() {
      return <Color> [
        Colors.redAccent,
        Color(0xff6750a4),
        Colors.blue,
        Colors.green,
        Colors.amberAccent,
        Colors.brown
      ];
    }

    ///Returns the GlobalKeys generated where they are needed to reference widgets to the tutorial
    List<GlobalKey> getTutorialKeys() {
      return _tutorialKeys;
    }
  }

class Hud extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HudState();
  Hud({super.key});
}

class HudState extends State<Hud> {
  int _currentIndex = 0;
  final List<String> _titleList = ["Home", "Categories"];
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }
  void changePage(int newPageIndex){
    setState(() {
      _currentIndex = newPageIndex;
      _title = _titleList[newPageIndex];
    });
  }

  //Checks for a Connectivity
  late StreamSubscription connection; //todo - add cancellation of subscription

  Tutorial _tutorial = Tutorial();

  /// _title dependant on _currentIndex and well update on change
  late String _title = _titleList[_currentIndex];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();


    //Code to check if there is a valid network connection
    connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      /// whenever connection status is changed.
      /// there isn´t any connection
      if (result == ConnectivityResult.none) {
        Future.delayed(Duration(seconds: 10), () {
          connectivityPopup(context: context); //todo - increase duration (it just delays the popup, it will show even after .1 seconds of no internet, just 10 seconds later)
        });
      } else if (result == ConnectivityResult.mobile) {
        /// connection is mobile data network
      } else if (result == ConnectivityResult.wifi) {
        ///connection is from wifi
      }
    });

    //todo - open overlay automatically when tutorial is shown, so that it opens the login screen of the app
    if(MyApp.of(context)._loadTutorial) {
      MyApp.of(context)._loadTutorial = false;
      _tutorial.createTutorial(MyApp.of(context).getTutorialKeys());
      _tutorial.showTutorial(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(title: Text(_title),
                //IconButton that lead to Charts
                actions: <Widget>[
                  IconButton(
                    iconSize: 30.0,
                    icon: const Icon(Icons.bar_chart),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChartsOverview()),);
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    icon: const Icon(Icons.menu),
                    onPressed:
                      _openEndDrawer,
                  ),
                ],
                automaticallyImplyLeading: false),
          body: PageView(
              controller: _pageController,
              onPageChanged: (newIndex) {
                changePage(newIndex);
              },
              children:[
                new Homepage(context: context),
                new CategoryOverview(),
              ],
            ),
            floatingActionButton: SpeedDial(
              //key: MyApp.of(context).getTutorialKeys()[2],
              // ToDo: menu_close is not the perfect icon, but not as confusing as the add event icon
              animatedIcon: AnimatedIcons.menu_close,
              spaceBetweenChildren: 10,
              openCloseDial: isDialOpen,
              children: [
                _currentIndex == 0 ? SpeedDialChild(
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
                    visible: _currentIndex == 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera),
                      onPressed: ()  async {
                        final cameras = await availableCameras();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: cameras.first)));
                        isDialOpen.value = false;
                      },
                    ),
                    label: "Open Camera"),
                //todo - remove button
                SpeedDialChild(
                    visible: true,
                    child: IconButton(
                      icon: const Icon(Icons.info_sharp),
                      onPressed: () async {
                        _tutorial.createTutorial(MyApp.of(context).getTutorialKeys());
                        _tutorial.showTutorial(context);
                        isDialOpen.value = false;
                      },
                    ),
                    label: "TutorialButton"),
              ],
            ),
            endDrawer: MenuDrawer(),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
            /// BottomNavigation bar will be rebuild when _currentIndex get changed
            bottomNavigationBar:
            BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: MyApp.of(context)._themeColor,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.euro_outlined, /*key: MyApp.of(context).getTutorialKeys()[0]*/),
                  label: "Expenses",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.inventory_2_outlined, /*key: MyApp.of(context).getTutorialKeys()[1]*/),
                    label: "Categories"),
              ],
              onTap: (newIndex) {
                _pageController.animateToPage(newIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
                changePage(newIndex);
              },
            )
        )
    );
  }
}

class MenuDrawer extends ReactiveWidget{
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Prop<bool> loginState = Prop(HTTPRequestBuilder().loggedIn);
    return Drawer(
        width: 250,
        child: ListView(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 60.0),
          children: [
            const Icon(Icons.account_circle_outlined, size: 100),
            loginState.value
                ? ListTile(
                    title: Text(
                        HTTPRequestBuilder().username[0].toUpperCase() +
                            HTTPRequestBuilder().username.substring(1),
                        textAlign: TextAlign.center),
                    subtitle: const Text('', textAlign: TextAlign.center))
                : const ListTile(
                    title: Text('User', textAlign: TextAlign.center),
                    subtitle: Text('', textAlign: TextAlign.center)),
            loginState.value
                ? ElevatedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(uniformSnackBar('Logged out!'));

                      //Navigate to the Login-Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(title: 'Login')),
                      );
                      UserState.of(context).logoutUser();
                    },
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: .01, color: Colors.grey)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 40),
                        Icon(Icons.login_outlined, size: 24.0),
                        SizedBox(width: 10),
                        Text("Logout"),
                      ],
                    ))
                : ElevatedButton(
                    onPressed: () async {
                      // Close drawer due to catch name and email from logged in user on successful login
                      Navigator.pop(context);
                      //Navigate to the Login-Screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login(title: 'Login')));
                    },
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: .01, color: Colors.grey)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 40),
                        Icon(Icons.login_outlined, size: 24.0),
                        SizedBox(width: 10),
                        Text("Login"),
                      ],
                    )),
            ElevatedButton(
              onPressed: () => colorPicker(currentColor: MyApp.of(context)._themeColor, currentThemeMode: MyApp.of(context)._themeMode, context: context),
            style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
            child: const Row(
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                Icon(Icons.info_outlined, size: 24.0),
                SizedBox(width: 10),
                Text('Info Screen'),
              ],
            ),
          ),
        ],
        )
    );
  }
}


