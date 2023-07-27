import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import '../UserState.dart';
import '../models/ExpenseList.dart';
import '../models/models.dart';
import 'package:money_mate/pages/EditCategory.dart';
import '../util/StateManagement.dart';
import 'CatExpense.dart';


/// Shows all Categories of an user
/// The Overview is updated when an instance of a category is added or changed
///
/// Code in [CategoryOverview.dart] by Daniel Ottolien
class CategoryOverview extends StatefulWidget {
  CategoryOverview({super.key});

  @override
  State<StatefulWidget> createState() => CategoryOverviewContent();
}

/// Shows an Overview of the Categories in a list
class CategoryOverviewContent extends State<CategoryOverview> {

  @override
  void initState() {
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

/// Displays the data for each category as a card
class CategoryCard extends StatelessWidget {

  Category category;
  late final BuildContext context;
  late final ExpenseList categoryExpenseList;

  CategoryCard({required this.context, required this.category, super.key}) {
    categoryExpenseList = UserState.of(context).expendList;
  }


  @override
  Widget build(BuildContext context) {

    /// Method to get the icon of a category
    /// compares the data of the variable catIcon to each case and returns IconData
    /// If no data is found a square will be set as default
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


    /// Method to get the spent budget of all expenses in a category
    /// Iterates over all expenses and returns the budget for those that match the categoryId
    int getBudgetofCategory() {

      int expensebudget = 0;
      for (Prop<Expense> expense in categoryExpenseList.value) {
        if ( expense.value.categoryId == category.id) {
          expensebudget += expense.value.amount.toInt();
        }
      }
      return expensebudget;
    }


    /// Method the show a warning if your set budget for a category has been spent
    /// If the spent budget of the expenses is bigger than the budget of the category
    /// a warning will be shown in the form of an Icon
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


    return SwipeActionCell(
      key: ValueKey(category),
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
            }),
        SwipeAction(
            content: _getIconButton(Colors.green, Icons.mode_edit),
            color: Colors.green,
            backgroundRadius: 10,
            onTap: (handler) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditCategory(category: category,))
              );
              handler(false);
            }),
      ],
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(getCategoryIcon(catIcon)),
              title: Text(category.name),
              subtitle: Row(
                  children: [Text(category.budget.toString() + ' €') ]
              ),
              trailing: getColor(),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CatExpense(category: category,))
          );
        },
            ),
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
      color: color,
    ),
    child: Icon(
      icon,
      color: Colors.white,
    ),
  );
}

/// Builds a listview for the category cards
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
        return CategoryCard(category: cats, context: context);
      },
    );
  }
}





