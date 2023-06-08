import 'package:flutter/material.dart';
import '../UserState.dart';
import '../models/models.dart';
import 'package:money_mate/pages/EditCategory.dart';
import '../util/Popups.dart';

class CategoryOverview extends StatelessWidget {
  const CategoryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CategoryListView(
          context: context,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  Category category;

  CategoryCard({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             ListTile(
              leading: Icon(Icons.album),
              title: Text(category.name),
              subtitle: Text(category.budget.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Edit'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCategory(category: category,)),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    deleteCategoryPopup(category: category, context: context);
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

/*
class CategoryListView extends StatelessWidget {
  // const CategoriesOverview({super.key});
  late final BuildContext context;
  late final List<Category> categoryListOverview;

  CategoryListView({required this.context, super.key}) {
    categoryListOverview = UserState.of(context).categoryList;
    }

  @override
  Widget build(BuildContext context) {
    */
/*return ListView(
      padding: const EdgeInsets.all(20.0),
      children: const <Widget>[
        CategoriesOverview(),
        CategoriesOverview(),

      ],
    );*//*

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
          child: ListView.builder(
            primary: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return CategoryCard(category: category);
            }),
      );
    });
  }
}


*/


class CategoryListView extends StatelessWidget {
  // const CategoriesOverview({super.key});
  late final BuildContext context;
  late final List<Category> categoryListOverview;

  CategoryListView({required this.context, super.key}) {
    categoryListOverview = UserState.of(context).categoryList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: categoryListOverview.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // return the header
              return Row(
                children: const [
                  Text("Please Add a Category"),
                ],
              );
            }
            index -= 1;
            var cats = categoryListOverview[index];
            return CategoryCard(category: cats);
          },
          // separatorBuilder: (BuildContext context, int index) =>
          // const Divider(),
        );
  }
}


