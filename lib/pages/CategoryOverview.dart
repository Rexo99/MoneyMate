import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../UserState.dart';
import '../models/models.dart';
import 'package:money_mate/pages/EditCategory.dart';
import '../util/Popups.dart';


/// To-Do make CategoryOverview Stateful
/// I still need to add set State
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

    // IconData getCategoryIcon() {
    //   if (category.icon.toString() == 'home') {
    //     return Icons.home;
    //   }
    //   else {
    //     return Icons.square;
    //   }
    // }

    String? catIcon = category.icon;

    IconData getCategoryIcon(catIcon) {
      switch(catIcon) {
        case '':
          return Icons.square;
          break;
        case 'home':
          return Icons.home;
          break;
        case 'car_repair':
          return Icons.car_repair;
          break;
        case 'local_grocery_store':
          return Icons.local_grocery_store;
          break;
        case 'local_bar':
          return Icons.local_bar;
          break;
        case 'flight':
          return Icons.flight;
          break;
        case 'business':
          return Icons.business;
          break;
        case 'album':
          return Icons.album;
          break;
        case 'pets':
          return Icons.pets;
          break;
        default:
          return Icons.square;
      }
    }

    Icon getColor(){
      if(category.budget.toInt() < 500) {
        return Icon(Icons.emoji_emotions,
          color: Colors.green);
      }
      else{
        return Icon(Icons.warning,
            color: Colors.red);
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
              // leading: Icon(Icons.local_grocery_store),
              /// To-Do get the Icondata over category.icon
              /// it´s not as simple as to convert String? to String
              /// As MdiIcons are different than normal Flutter Icon it´s not
              /// the best solution
              // leading: Icon(MdiIcons.fromString(category.icon.toString())),
              leading: Icon(getCategoryIcon(catIcon)),
              title: Text(category.name),
              subtitle: Text(category.budget.toString() + ' €'),
              /*trailing: Icon(Icons.circle,
              color: getColor(),),*/
              trailing: getColor(),
              /// Add Something like a small circle in order to indicate the budget status
              /// maybe through box decoration
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


