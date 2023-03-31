import 'package:cash_crab/UserState.dart';
import 'package:cash_crab/pages/CategoryOverview.dart';
import 'package:cash_crab/pages/Homepage.dart';
import 'package:cash_crab/state.dart';
import 'package:cash_crab/util/HTTPRequestBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: UserState(child: HUD()),
    );
  }
}

class HUD extends StatelessWidget {
  final Prop<int> _currentIndex = Prop(0);
  final List<String> _titleList = ["Home", "Categories"];
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
          children: const[
            Homepage(),
            CategoriesOverview(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Todo change for production
            HTTPRequestBuilder().login(name: "erik", password: "test");
            UserState.of(context).addItem(name: "Döner", amount: 3);
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: $(
            _currentIndex,
            (int index) => BottomNavigationBar(
                  currentIndex: _currentIndex.value,
                  unselectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.play_arrow_rounded),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search), label: "Categories"),
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
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
