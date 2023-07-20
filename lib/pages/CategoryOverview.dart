import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import '../UserState.dart';
import '../models/models.dart';
import 'package:money_mate/pages/EditCategory.dart';
import '../util/Popups.dart';


//To-Do make CategoryOverview Stateful
class CategoryOverview extends StatefulWidget {
  CategoryOverview({super.key});

  @override
  State<StatefulWidget> createState() => CategoryOverviewContent();
}

class CategoryOverviewContent extends State<CategoryOverview> {

  @override
  void initState() {
    /// check if the state of the items has changed
    /// when name or budget is different
    super.initState();
  }

  void update() {

  }

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

    //Method to Change the Color depending on the budget spent
    // For Example if the expenses of the Category are bigger than 70% of it´s budget
    Color getColor(){
      if(category.budget.toInt() < 500) {
        return Colors.green;
      }
      else{
        return Colors.red;
      }

    }


    // return Center(
    return SwipeActionCell(

      // Required!
      key: ValueKey(category),

      // Animation default value below
      // normalAnimationDuration: 400,
      // deleteAnimationDuration: 400,
      selectedForegroundColor: Colors.black.withAlpha(30),
      trailingActions: [
        SwipeAction(
            content: _getIconButton(Colors.red, Icons.delete),
            backgroundRadius: 10,
            performsFirstActionWithFullSwipe: true,
            nestedAction: SwipeNestedAction(
              content: Container(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('confirm',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
            onTap: (handler) async {
              await handler(true);
              UserState.of(context).removeCategory(category);
              // deleteCategoryPopup(category: category, context: context);
            }),
        SwipeAction(
            content: _getIconButton(Colors.green, Icons.mode_edit),
            color: Colors.green,
            backgroundRadius: 10,
            onTap: (handler) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditCategory(category: category,)),
              );
              handler(false);
            }),
      ],
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.local_grocery_store),
              title: Text(category.name),
              subtitle: Text(category.budget.toString() + ' €'),
              //Changes color of a list tile
              tileColor: getColor(),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: <Widget>[
            //     TextButton(
            //       child: const Text('Edit'),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => EditCategory(category: category,)),
            //         );
            //       },
            //     ),
            //     const SizedBox(width: 8),
            //     TextButton(
            //       child: const Text('Delete'),
            //       onPressed: () {
            //         deleteCategoryPopup(category: category, context: context);
            //       },
            //     ),
            //     const SizedBox(width: 8),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

Widget _getIconButton(color, icon) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),

      /// set you real bg color in your content
      color: color,
    ),
    child: Icon(
      icon,
      color: Colors.white,
    ),
  );
}


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
              Text("Your categories:"),
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


