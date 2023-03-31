import 'package:cash_crab/util/Formatter.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
import '../util/Popups.dart';

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
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: const <Widget>[
        CategoriesOverview(),
        CategoriesOverview(),
        CategoriesOverview(),
        CategoriesOverview(),
        CategoriesOverview(),
        CategoriesOverview(),
        CategoriesOverview(),
        CategoriesOverview(),
      ],
    );
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
          child: Scrollbar(
        thumbVisibility: true,
        //Todo pit sagt ListView reicht aus
        child: ListView.builder(
            primary: true,
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return CategoriesOverview();
            }),
      ));
    });
  }
}


