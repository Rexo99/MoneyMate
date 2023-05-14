import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/pages/CategoryOverview.dart';
import 'package:money_mate/pages/Homepage.dart';
import 'package:money_mate/pages/Info.dart';
import 'package:money_mate/pages/Login.dart';
import 'package:money_mate/state.dart';
import 'package:money_mate/util/CameraNew.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
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
    void initState() {
      //todo - load app settings on initialization
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
        colorSchemeSeed: _themeColor, brightness: Brightness.dark, useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: UserState(child: Hud()),
    );
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

  String loginButtonText = 'Login'; //doesn't save value on page switch //todo - change value according to users loggedIn state

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
              children: const [
                Homepage(),
                CategoriesOverview(),
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
                        UserState.of(context)
                            .addItem(name: "Döner", amount: 3);
                        isDialOpen.value = false;
                      },
                    ),
                    label: "Add Expense",
                  ) : SpeedDialChild(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        //Todo addCategory

                        //UserState.of(context).addCategory(name: "nameTestLol2", budget: 100);
                        //UserState.of(context).removeCategory(UserState.of(context).categoryList.last);
                        //UserState.of(context).updateCategory(category: UserState.of(context).categoryList.last, budget: 1234);
                        isDialOpen.value = false;
                      },
                    ),
                    label: "Add Category",
                  ),
                  SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () async {
                          await HTTPRequestBuilder()
                              .login(name: "erik", password: "test");
                          if (context.mounted &&
                              UserState.of(context).expendList.value.isEmpty) {
                            UserState.of(context).initListExpenseList();
                            UserState.of(context).initListCategoryList();
                          }
                          isDialOpen.value = false;
                        },
                      ),
                      label: "Login"),
                  SpeedDialChild(
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
                ],
              ),
            ),
            endDrawer: Drawer(
              width: 250,
              child: ListView(children: [
                Icon(Icons.account_circle_outlined, size: 100),
                ListTile(
                  title: Text('User XXX', textAlign: TextAlign.center),
                  subtitle: Text('UserXXX@mail.com', textAlign: TextAlign.center),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //Navigate to the Login-Screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: 'Login')),);

                    //start of content that needs do be deleted //todo - find other way to find out if the user is logged in and change the value of loginButtonText accordingly
                    if(loginButtonText == 'Login') {
                      //todo - move login request to login screen
                      await HTTPRequestBuilder().login(name: "erik", password: "test");
                      print(UserState.of(context).expendList.value.isEmpty);
                      if (context.mounted &&
                          UserState.of(context).expendList.value.isEmpty) {
                        UserState.of(context).initListExpenseList();
                        loginButtonText = 'Logout';
                      } else {
                        //todo - implement logout
                        UserState.of(context).logoutUser(); //not working yet
                        loginButtonText = 'Login';
                      }
                    } //end of content that needs do be deleted
                    },
                  style: ElevatedButton.styleFrom(side: const BorderSide(width: .01, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 40),
                      Icon(Icons.login_outlined, size: 24.0),
                      SizedBox(width: 10),
                      Text('Login'),
                    ],
                  ),
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
              ],
              )
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
            /// BottomNavigation bar will be rebuild when _currentIndex get changed
            bottomNavigationBar: $(
                _currentIndex,
                (int index) => BottomNavigationBar(
                      currentIndex: _currentIndex.value,
                      unselectedItemColor: Colors.black,
                      items: const [
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

/* Useless class
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final double height = 50;

  const TopBar({super.key, this.title = const Text("No Title")});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: [
        Builder(
            builder: (BuildContext context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                )
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
 */
