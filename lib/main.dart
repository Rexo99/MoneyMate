import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    ///Tutorial related
    bool _loadTutorial = false;

    @override
    void initState() {
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
        home: Login(title: 'Login'),
        debugShowCheckedModeBanner: false,
      );
    }

    ///Checks SharedPreferences whether the app is started for the first time after installing or not
    Future checkFirstSeen() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? _seen = (prefs.getBool('tutorialSeen'));

      if(_seen == null || _seen == false) {
        _loadTutorial = true;
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
  }

class Hud extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HudState();
  Hud({super.key});
}

class HudState extends State<Hud> {
  final Prop<int> _currentIndex = Prop(0);
  final List<String> _titleList = ["Home", "Categories"];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Checks for a Connectivity
  late StreamSubscription connection; //todo - add cancellation of subscription

  TutorialState _tutorial = TutorialState();

  /// _title dependant on _currentIndex and well update on change
  late final ComputedProp<String> _title = ComputedProp(() => _titleList[_currentIndex.value], [_currentIndex]);
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

    if(MyApp.of(context)._loadTutorial) {
      MyApp.of(context)._loadTutorial = false;
      _tutorial.createTutorial();
      _tutorial.showTutorial(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(title: $(_title, (String title) => Text(title)),
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
                      _toggleEndDrawer,
                  ),
                ],
                automaticallyImplyLeading: false),
          body: PageView(
              controller: _pageController,
              onPageChanged: (newIndex) {
                _currentIndex.value = newIndex;
              },
              children:[
                new Homepage(context: context),
                new CategoryOverview(),
              ],
            ),
            floatingActionButton: $(
              _currentIndex, (p0) => FloatingActionButton(
                onPressed: () {
                  if(_currentIndex.value == 0) {
                    createExpensePopup(context: context);
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory()),);
                  }
                },
                child: Icon(Icons.add),
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
                          icon: Icon(Icons.euro_outlined),
                          label: "Expenses",
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.inventory_2_outlined),
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

  void _toggleEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }
}

class MenuDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Prop<bool> _loginState = Prop(HTTPRequestBuilder().loggedIn);
    return Drawer(
        width: 250,
        child: ListView(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 60.0),
          children: [
          const Icon(Icons.account_circle_outlined, size: 100),
          $(_loginState, (p0) => _loginState.value
            ? ListTile(
                title: Text(HTTPRequestBuilder().username[0].toUpperCase() + HTTPRequestBuilder().username.substring(1), textAlign: TextAlign.center),
                subtitle: const Text('', textAlign: TextAlign.center))
            : const ListTile(
                title: Text('User', textAlign: TextAlign.center),
              subtitle: Text('', textAlign: TextAlign.center)),
           ),
          $(_loginState, (p0) => _loginState.value
              ? ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                        uniformSnackBar('Logged out!')
                    );
                    //Navigate to the Login-Screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: 'Login')),);
                    UserState.of(context).logoutUser();
                  },
                  style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 25),
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
                },
                style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Icon(Icons.login_outlined, size: 24.0),
                    SizedBox(width: 10),
                    Text("Login"),
                  ],
                )
              )
          ),
          ElevatedButton(
            onPressed: () => themePicker(currentColor: MyApp.of(context)._themeColor, currentThemeMode: MyApp.of(context)._themeMode, context: context),
            style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 25),
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
                SizedBox(width: 25),
                Icon(Icons.info_outlined, size: 24.0),
                SizedBox(width: 10),
                Text('Info Screen'),
              ],
            ),
          ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                TutorialState _tutorial = TutorialState();
                _tutorial.createTutorial();
                _tutorial.showTutorial(context);
              },
              style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 25),
                  Icon(Icons.accessibility, size: 24.0),
                  SizedBox(width: 10),
                  Text('Rewatch Tutorial'),
                ],
              ),
            ),
              //todo - remove camera button
              ElevatedButton(
                onPressed: () async {
                Navigator.of(context).pop();
                final cameras = await availableCameras();
                Navigator.push(context, MaterialPageRoute(builder: (context) => InitializeCamera(camera: cameras.first)));
                },
                style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Icon(Icons.accessibility, size: 24.0),
                    SizedBox(width: 10),
                    Text('Camera Test'),
                  ],
                ),
              ),
        ],
        )
    );
  }
}


