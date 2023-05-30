import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
import 'package:money_mate/pages/EditCategory.dart';
import '../util/Popups.dart';

class CategoryCard extends StatelessWidget {
  // const CategoryCard({super.key});
  late final BuildContext context;
  late final List<Category> categoryListOverview;

  CategoryCard({required this.context, super.key}) {
    categoryListOverview = UserState.of(context).categoryList;
  }



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
                  child: const Text('Bearbeiten'),
                  onPressed: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCategory(category: category,)),
                    );*/
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Löschen'),
                  onPressed: () {
                    /*DeleteCategoryPopup(category: category, context: context);*/
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
              return CategoryCard(context: context);
            }),
      );
    });
  }
}


