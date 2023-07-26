import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:money_mate/models/ExpenseList.dart';
import 'package:money_mate/util/DateTimeExtensions.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../util/StateManagement.dart';
import 'ExpenseOverview.dart';

class Homepage extends StatelessWidget {
  late ExpenseList expenseList;

  Homepage({required BuildContext context, super.key}) {
    expenseList = UserState.of(context).expendList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          HTTPRequestBuilder().loggedIn
              ? CardListBuilder(
                  expenseList: expenseList,
                  count: 3,
                )
              : const Text("Please login"),
          ElevatedButton(
              //key: MyApp.of(context).getTutorialKeys()[3],
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExpenseOverview())),
              child: const Text("See All")),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HTTPRequestBuilder().loggedIn
                  ? TotalExpense(
                  title: "Today",
                  amount: num.tryParse(expenseList
                      .getTotalToday()
                      .toStringAsFixed(1)))
                  : TotalExpense(title: "Today", amount: 0),
              HTTPRequestBuilder().loggedIn
                  ? TotalExpense(
                  title: "Month",
                  amount: num.tryParse(expenseList
                      .getTotalMonth()
                      .toStringAsFixed(1)))
                  : TotalExpense(title: "Month", amount: 0)
            ],
          )
        ],
      )),
    );
  }
}

class ExpenseCard extends ReactiveWidget {
  late final ExpenseList expenseList;
  final Prop<Expense> expense;
  final int index;

  ExpenseCard(
      {required this.expense,
      required this.index,
      required context,
      super.key}) {
    expenseList = UserState.of(context).expendList;
  }

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      index: index,

      // Required!
      key: ValueKey(expenseList.value[index]),

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
              content: const OverflowBox(
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
            onTap: (handler) async {
              await handler(true);
              expenseList.removeItem(expense.value);
            }),
        SwipeAction(
            content: _getIconButton(Colors.green, Icons.mode_edit),
            color: Colors.green,
            backgroundRadius: 10,
            onTap: (handler) {
              updateExpensePopup(expense: expense, context: context);
              handler(false);

            }),
      ],
      /* child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text("This is index of ${list[index]}",
            style: const TextStyle(fontSize: 30)),
      ),*/
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(UserState.of(context).getIconFromCategoryId(categoryId: expense.value.categoryId)),
              title: Text(expense.value.name),
              subtitle: Row(
                children: [
                  Text("Amount: ${expense.value.amount} €"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Date: ${expense.value.date.dateFormatter()}"),
                  )
                ],
              ),
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

      /// set you real bg color in your content
      color: color,
    ),
    child: Icon(
      icon,
      color: Colors.white,
    ),
  );
}


/// [count] of cards that should be build (default = 3)
class CardListBuilder extends ReactiveWidget {
  final ExpenseList expenseList;
  final int count;

  CardListBuilder(
      {required this.expenseList,
      this.count = 3,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        height: 250,
        child: ListView.builder(
            primary: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              if(expenseList.length > index) {
                Prop<Expense> expense = expenseList.value[index];
                return ExpenseCard(
                  expense: expense,
                  index: index,
                  context: context,
                );
              }
              return null;
            }),
      );
    });
  }
}

class TotalExpense extends StatelessWidget {
  final String title;
  final num? amount;

  const TotalExpense({this.title = "none", this.amount, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            amount == null || amount == 0.0
                ? const Text(
                    "_ _",
                    style: TextStyle(fontSize: 30),
                  )
                : Text(
                    "${amount}0 €",
                    style: const TextStyle(fontSize: 30),
                  ),
            Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ));
  }
}
