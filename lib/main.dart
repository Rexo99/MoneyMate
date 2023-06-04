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
import 'package:money_mate/state.dart';
import 'package:money_mate/util/CameraNew.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UserState.dart';

Future<void> main() async {
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
    ThemeMode _themeMode = ThemeMode.system;
    Color _themeColor = Color(0xff6750a4);

    @override
    void initState()  {
      //todo - load app settings on initialization
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
          colorSchemeSeed: _themeColor,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        //home: _startWidget,
        home: new LoadingScreen(),
      ));
    }

    //used to change between light/dark/system mode
    Future<void> changeTheme(ThemeMode themeMode) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('themeMode', getThemeModes().indexOf(themeMode));
      setState(() {
        _themeMode = themeMode;
      });
    }

    ThemeMode getCurrentThemeMode() {
      return _themeMode;
    }

    List<ThemeMode> getThemeModes() {
      return <ThemeMode> [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    }

    //used to change themeColor //todo - figure out how to create a whole color palette instead of using a color as a seed
    Future<void> changeThemeColor(Color color) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('themeColor', getThemeColors().indexOf(color));
      setState(() {
        _themeColor = color;
      });
    }

    List<Color> getThemeColors() {
      return <Color> [
        Colors.red,
        Color(0xff6750a4),
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.brown
      ];
    }
  }

class LoadingScreen extends StatefulWidget {
  @override
  LoadingScreenState createState() => new LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    checkFirstSeen();
    checkTheme();
    super.initState();
  }

  //todo - add more to loading screen (like loading animation etc.)
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('tutorialSeen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Login(title: 'Login')));
    } else {
      await prefs.setBool('tutorialSeen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => TutorialTest()));
    }
  }

  Future<void> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? themeMode = prefs.getInt('themeMode');
    if(themeMode != null) {
      MyApp.of(context).changeTheme(MyApp.of(context).getThemeModes().elementAt(themeMode));
    }

    int? themeColor = prefs.getInt('themeColor');
    if(themeColor != null) {
      MyApp.of(context).changeThemeColor(MyApp.of(context).getThemeColors().elementAt(themeColor));
    }
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
                Homepage(context: context, foreignKey: new GlobalKey(),),
                const CategoryOverview(),
              ],
            ),
            floatingActionButton: $(
              _currentIndex, (p0) => SpeedDial(
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


