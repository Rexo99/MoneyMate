import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key, required this.title});

  final String title;

  void _doNothing() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          color: Color(0xff6750a4),
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            children: [
              const SizedBox(height: 30),
              Text("Das MoneyMate Team:",
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                  )
              ),
              const SizedBox(height: 60),
              Image.network("https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png"),
              const SizedBox(height: 60),
            ],
          )
      ),
    );
  }
}