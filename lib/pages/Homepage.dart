import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:money_mate/models/ExpenseList.dart';
import 'package:money_mate/util/DateTimeExtensions.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import 'package:money_mate/util/Popups.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
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
              ? $(
                  expenseList,
                  (p0) => CardListBuilder(
                      objectList: expenseList.findNewest(3), cardType: Expense, count: 3))
              : const Text("Please login"),
          ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExpenseOverview())),
              child: const Text("See All")),
          $(
              expenseList,
              (p) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HTTPRequestBuilder().loggedIn
                          ? TotalExpense(
                              title: "Total",
                              amount: expenseList.getTotalToday())
                          : TotalExpense(title: "Total", amount: 0),
                      HTTPRequestBuilder().loggedIn
                          ? TotalExpense(
                              title: "Total",
                              amount: expenseList.getTotalMonth())
                          : TotalExpense(title: "Month", amount: 0)
                    ],
                  ))
        ],
      )),
    );
  }
}

class ExpenseCard extends StatelessWidget {
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
    //Todo Wrapper for slide options
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
            title: "delete",
            backgroundRadius: 10,
            performsFirstActionWithFullSwipe: true,
            nestedAction: SwipeNestedAction(title: "confirm"),
            onTap: (handler) async {
              await handler(true);
              expenseList.removeItem(expense);
            }),
        SwipeAction(
            title: "Update",
            color: Colors.grey,
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
            //Todo Display Timestamp
            //Todo rearrange Textiles
            ListTile(
              leading: Icon(Icons.album),
              title: Text(expense.value.name),
              subtitle: Row(children: [Text("Amount: ${expense.value.amount}"),Text("Date: ${expense.value.date.dateFormatter}")],),
            ),
          ],
        ),
      ),
    );
  }
}

/// Build a List of Card Widgets from a List
/// [objectList] needs an [IList] of [Model]
/// [cardType] needs a [Model]
/// [count] of cards that should be build (default = 3)
class CardListBuilder<T extends IList<Prop<Expense>>> extends StatelessWidget {
  T objectList;
  final Type cardType;
  final int count;

  CardListBuilder(
      {required this.objectList,
      required this.cardType,
      this.count = 3,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        height: 300,
        child: ListView.builder(
            primary: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              switch (cardType) {
                case Expense:
                  Prop<Expense>? expense = objectList.getOrNull(index);
                  if (expense != null) {
                    return $(expense, (p1) => ExpenseCard(
                      expense: expense,
                      index: index,
                      context: context,
                    ));
                  }
                  return null;
                case Category:
                  throw UnimplementedError();
              }
              return null;
            }),
      );
    });
  }
}

class TotalExpense extends StatelessWidget {
  final String title;
  final double? amount;

  const TotalExpense({this.title = "none", this.amount, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            amount == null || amount == 0.0
                ? const Text(
                    "_ _",
                    style: TextStyle(fontSize: 40),
                  )
                : Text(
                    "${amount}0€",
                    style: const TextStyle(fontSize: 40),
                  ),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ));
  }
}
