import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/models/ExpenseList.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
import 'ExpenseOverview.dart';

class Homepage extends StatelessWidget {
  late final ExpenseList expenseList;

  Homepage({required BuildContext context,super.key}) {
    expenseList = UserState
        .of(context)
        .expendList;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: Column(
            children: [
              HTTPRequestBuilder().getLoginState()
              //Todo show last expenses and refresh on adding a new one
                  ? CardListBuilder(
                  objectList: expenseList,
                  cardType: Expense,
                  count: 3)
                  : const Text("Please login"),
              ElevatedButton(
                  onPressed: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExpenseOverview())),
                  child: const Text("See All")),
              $(expenseList, (p) => Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TotalExpense(title: "Today", amount: expenseList.getTotalToday()),
                  TotalExpense(title: "Month", amount: expenseList.getTotalMonth(),)
                ],)
              )
            ],
          )),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  Prop<Expense> expense;

  ExpenseCard(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    //Todo Wrapper for slide options
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Todo Display Timestamp
          //Todo rearrange Textiles
          ListTile(
            leading: Icon(Icons.album),
            title: Text(expense.value.name),
            subtitle: Text("Amount: ${expense.value.amount}"),
          ),
        ],
      ),
    );
  }
}

/// Build a List of Card Widgets from a List
/// [objectList] needs an [IList] of [Model]
/// [cardType] needs a [Model]
/// [count] of cards that should be build
class CardListBuilder<T extends Prop<IList>> extends StatelessWidget {
  T objectList;
  Type cardType;
  int count = 3;

  CardListBuilder({required this.objectList,
    required this.cardType,
    required this.count,
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
                      ValueNotifier<Expense>? expense =
                      objectList.value.getOrNull(index);
                      if (expense != null) {
                        return ExpenseCard(expense);
                      }
                      return null;
                    case Category:
                      throw UnimplementedError();
                  }
                }),
          );
        });
  }
}

class TotalExpense extends StatelessWidget {
  final String title;
  double? amount;

  TotalExpense({this.title = "none", this.amount, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            amount == null
                ? const Text(
              "__",
              style: TextStyle(fontSize: 40),
            )
                : Text(
              "$amount",
              style: TextStyle(fontSize: 40),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ));
  }
}
