import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

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
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {
                    /* ... */
                  },
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

class CategoriesOverview extends StatelessWidget {
  const CategoriesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    /*return ListView(
      padding: const EdgeInsets.all(20.0),
      children: const <Widget>[
        CategoriesOverview(),
        CategoriesOverview(),

      ],
    );*/
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
          child: ListView.builder(
            primary: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return CategoryCard();
            }),
      );
    });
  }
}


