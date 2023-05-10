import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/pages/CategoryOverview.dart';
import 'package:money_mate/pages/Homepage.dart';
import 'package:money_mate/pages/Info.dart';
import 'package:money_mate/state.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'UserState.dart';

Future<void> main() async {
  //await dotenv.load(fileName: '.env');
  Intl.defaultLocale = 'pt_BR';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Money Mate',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      // device controls theme
      home: UserState(child: HUD()),
    );
  }
}

class HUD extends StatelessWidget {
  final Prop<int> _currentIndex = Prop(0);
  final List<String> _titleList = ["Home", "Categories"];

  /// _title dependant on _currentIndex and well update on change
  late final ComputedProp<String> _title =
      ComputedProp(() => _titleList[_currentIndex.value], [_currentIndex]);
  final PageController _pageController = PageController(initialPage: 0);

  HUD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Topbar(title: $(_title, (String title) => Text(title))),
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

        /// Button located at the bottom center of the screen
        /// The Button expand on click and
        /// reveal two options to add an [Expense]
        /// 1. manual input of name and amount
        /// 2. take a picture of bill
        floatingActionButton: $(
          _currentIndex,
          (p0) => SpeedDial(
            // ToDo: menu_close is not the perfect icon, but not as confusing as the add event icon
            animatedIcon: AnimatedIcons.menu_close,
            spaceBetweenChildren: 10,
            children: [
              _currentIndex.value == 0
                  ? SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.euro),
                        onPressed: () {
                          UserState.of(context)
                              .addItem(name: "Döner", amount: 3);
                        },
                      ),
                      label: "Add Expense",
                    )
                  : SpeedDialChild(
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          //Todo addCategory
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
                      }
                    },
                  ),
                  label: "Login"),
              SpeedDialChild(
                  child: IconButton(
                    icon: const Icon(Icons.bug_report),
                    onPressed: () async {
                      await UserState.of(context)
                          .registerUser(name: "dannie1", password: "ee");
                    },
                  ),
                  label: "DevelopmentButton"),
            ],
          ),
        ),

        ///info of the active user
        ///LogoutButton
        ///Button that navigates to the Info-Screen
        endDrawer: Drawer(
            child: ListView(children: [
          Icon(Icons.account_circle_outlined, size: 100),
          ListTile(
            title: Text('User XXX', textAlign: TextAlign.center),
            subtitle: Text('UserXXX@mail.com', textAlign: TextAlign.center),
          ),
          ElevatedButton(
              onPressed: () async {
                await HTTPRequestBuilder()
                    .login(name: "erik", password: "test");
                print(UserState.of(context).expendList.value.isEmpty);
                if (context.mounted &&
                    UserState.of(context).expendList.value.isEmpty) {
                  UserState.of(context).initListExpenseList();
                }
              },
              child: const Text('Login')),
          ElevatedButton(
              onPressed: () {
                //Navigate to the Info-Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Info(title: 'Info')),
                );
              },
              child: const Text('Info-Screen')),
        ])),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,

        /// BottomNavigation bar will be, rebuild when _currentIndex get changed
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
                )));
  }
}

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final double height = 50;

  const Topbar({super.key, this.title = const Text("No Title")});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: [
        Builder(
            builder: (BuildContext context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
