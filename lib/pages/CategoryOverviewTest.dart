import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/util/DateTimeExtensions.dart';
import '../UserState.dart';
import '../models/dtos.dart';
import '../models/models.dart';
import '../state.dart';
import 'package:money_mate/pages/EditCategory.dart';
import '../util/Popups.dart';

class CategoryOverviewTest extends StatelessWidget {
  const CategoryOverviewTest({super.key});

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

/*class ListEntry extends StatelessWidget {
  Prop<Expense> expense;

  ListEntry({required this.expense, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () =>
            updateExpensePopup(expense: expense, context: context),
        child: ListTile(
          //return new ListTile(
          leading: const CircleAvatar(
            //Todo CategoryIcons
            backgroundColor: Colors.blue,
            child: Text("Icon"),
          ),
          title: Row(children: <Widget>[
            $(
                expense,
                    (e) => Text(
                    "${e.name}  ${e.amount.toString()}  ${e.date.dateFormatter()}")),
            MaterialButton(
                child: const Text('Delete'),
                color: Colors.red,
                onPressed: () {
                  UserState.of(context).expendList.removeItem(expense);
                }),
          ]),
        ));
  }
}*/


// Einzelnes Listenelement in der Kategorie
/*class ListEntry extends StatelessWidget {
  Prop<Category> category;

  ListEntry({required this.category,super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: $(
                  category,
                      (c) => Text(
                      "${c.name}")),
              subtitle: $(
                  category,
                      (c) => Text(
                      "${c.budget.toString()}")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Bearbeiten'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCategory()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Löschen'),
                  onPressed: () {
                    DeleteCategoryPopup(context: context);
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
}*/

class ListEntry extends StatelessWidget {
  List<Category> categoryList;

  ListEntry({required this.categoryList,super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: todo,
              subtitle: todo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Bearbeiten'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCategory()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Löschen'),
                  onPressed: () {
                    DeleteCategoryPopup(context: context);
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


class CategoryListView extends StatelessWidget {
  late final BuildContext context;
  late final List<Category> categoryListOverview;

  CategoryListView({required this.context, super.key}) {
    categoryListOverview = UserState.of(context).categoryList;
  }

  @override
  Widget build(BuildContext context) {
    return $(
        categoryList,
            (expenses) => ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: categoryList.value.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // return the header
              return Row(
                children: const [
                  Text("Name       "),
                  Text("Amount       "),
                  Text("Date"),
                ],
              );
            }
            index -= 1;
            var cats = categoryListOverview.value.get(index);
            return ListEntry(category: cats);
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        ));
  }
}