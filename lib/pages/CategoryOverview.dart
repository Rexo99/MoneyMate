import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import '../UserState.dart';
import '../models/models.dart';
import 'package:money_mate/pages/EditCategory.dart';



/// To-Do make CategoryOverview Stateful
/// I still need to add set State
/// seems to be correct
class CategoryOverview extends StatefulWidget {
  CategoryOverview({super.key});

  @override
  State<StatefulWidget> createState() => CategoryOverviewContent();
}

///Seems to be correct to
/// need to add a way to see if the data has been changed
class CategoryOverviewContent extends State<CategoryOverview> {

  @override
  void initState() {
    /// check if the state of the items has changed
    /// when name or budget is different
    super.initState();
  }

  void update() {
    setState(() {

    });
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

///no changes required?
class CategoryCard extends StatelessWidget {
  Category category;

  List<Expense> categoryExpenseList = [];
  // late List<Expense> categoryExpenseList = [Expense('test', 400, DateTime.now(), 56)];
  // late final List<Expense> categoryExpenseList = await getexpenseList();
  // late final List<Expense> exps;

  CategoryCard({required this.category, super.key});



  @override
  Widget build(BuildContext context) {
    /*Future<List<Expense>> initexpenseList() async {
      List<Expense> categoryExpenseList = await getexpenseList();
      return categoryExpenseList;
    }
    initexpenseList();*/

    Future<void> initexpenseList() async {
      categoryExpenseList = await getexpenseList();
    }
    initexpenseList();

    /// Method to get the icon of a category
    String? catIcon = category.icon;
    IconData getCategoryIcon(catIcon) {
      switch(catIcon) {
        case '':
          return Icons.square;
        case 'home':
          return Icons.home;
        case 'car_repair':
          return Icons.car_repair;
        case 'local_grocery_store':
          return Icons.local_grocery_store;
        case 'local_bar':
          return Icons.local_bar;
        case 'flight':
          return Icons.flight;
        case 'business':
          return Icons.business;
        case 'album':
          return Icons.album;
        case 'pets':
          return Icons.pets;
        default:
          return Icons.square;
      }
    }

    /// Method to get the expense List
    /*Future<List<Expense>> getexpenseList() async {
      List<Expense> exps = (await HTTPRequestBuilder().get(
          path: "expenditures",
          returnType: List<Expense>)) as List<Expense>;
      return exps;
    }*/

    /// Method to get the spent budget of all expenses in a category
    int getBudgetofCategory() {

      int expensebudget = 0;
      for (var expense in categoryExpenseList) {
        if ( expense.categoryId == category.id) {
          expensebudget += expense.amount.toInt();
        }
      }
      return expensebudget;
    }



    ///Method the show a warning if your budget has been spent
    Icon getColor(){
      if(getBudgetofCategory() > category.budget.toInt()) {
        return Icon(Icons.warning,
            color: Colors.red);
      }
      else{
        return Icon(Icons.emoji_emotions,
            color: Colors.green);
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
              // leading: Icon(MdiIcons.fromString(category.icon.toString())),
              leading: Icon(getCategoryIcon(catIcon)),
              title: Text(category.name),
              subtitle: Text(category.budget.toString() + ' €'),
              /*subtitle: Column(
                children: <Widget>[
                  Text('inside column'),
                  TextButton(child: Text('button'), onPressed: () {
                    print(categoryExpenseList);
                  })
                ],
              ),*/
              /*trailing: Icon(Icons.circle,
              color: getColor(),),*/
              trailing: getColor(),
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

/// get the ExpenseList
Future<List<Expense>> getexpenseList() async {
  List<Expense> exps = (await HTTPRequestBuilder().get(
      path: "expenditures",
      returnType: List<Expense>)) as List<Expense>;
  print(exps);
  return exps;
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

/// doesn´t need any changes
class CategoryListView extends StatelessWidget {
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





