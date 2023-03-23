import 'package:flutter/material.dart';

class CategoryOverview extends StatelessWidget {
  const CategoryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:_MyStatefulWidgetState() ,
      ),
    );
  }
}


class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _MyStatefulWidgetState extends StatelessWidget {
  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            // This vertical scroll view has primary set to true, so it is
            // using the PrimaryScrollController. On mobile platforms, the
            // PrimaryScrollController automatically attaches to vertical
            // ScrollViews, unlike on Desktop platforms, where the primary
            // parameter is required.
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                    primary: true,
                    itemCount: 100,
                    itemBuilder: (BuildContext context, int index) {
                      return MyStatelessWidget();
                    }),
              ));
        });
  }
}