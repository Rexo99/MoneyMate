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

/// The Homepage widget represents the main page of the application,
/// displaying the last 3 expenses and total expense amounts for today and the month.
/// Code by Erik Hinkelmanns, Dannie Krösche, Dorian Zimmermann
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
                      objectList: expenseList.findNewest(3),
                      cardType: Expense,
                      count: 3))
              : const Text("Please login"),
              ElevatedButton(
                //key: MyApp.of(context).getTutorialKeys()[3],
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
                              title: "Today",
                              amount: num.tryParse(expenseList.getTotalToday().toStringAsFixed(1)))
                          : TotalExpense(title: "Today", amount: 0),
                      HTTPRequestBuilder().loggedIn
                          ? TotalExpense(
                              title: "Month",
                              amount: num.tryParse(expenseList.getTotalMonth().toStringAsFixed(1)))
                          : TotalExpense(title: "Month", amount: 0)
                    ],
                  )
              )
        ],
      )),
    );
  }
}

/// expense card with swipe actions for deleting and editing expenses,
/// as well as displaying details and handling image functionality.
/// Code by Erik Hinkelmanns, Dannie Krösche
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
              expenseList.removeItem(expense);
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
              onTap: () async {
                if (expense.value.imageId != null) {
                  try{
                    var imageBytes = await UserState.of(context).builder.getImage(imageId: expense.value.imageId);
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0))
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.memory(
                          imageBytes,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }
                  catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        uniformSnackBar('Could not load image')
                    );
                  }
                }
                else
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                      uniformSnackBar('Expense has no image attached')
                  );
                }
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

/// Build a List of Card Widgets from a List
/// [objectList] needs an [IList] of [Model]
/// [cardType] needs a [Model]
/// [count] of cards that should be build (default = 3)
/// Code by Erik Hinkelmanns
class CardListBuilder<T extends IList<Prop<Expense>>> extends StatelessWidget {
  final T objectList;
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
        height: 250,
        child: ListView.builder(
            primary: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              switch (cardType) {
                case Expense:
                  Prop<Expense>? expense = objectList.getOrNull(index);
                  if (expense != null) {
                    return $(
                        expense,
                        (p1) => ExpenseCard(
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

/// Widget with titel and amount used for displaying monthly and daly total expenses
/// Code by Erik Hinkelmanns
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
