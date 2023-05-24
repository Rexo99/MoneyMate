import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/util/DateTimeExtensions.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
import '../util/Popups.dart';

class ExpenseOverview extends StatelessWidget {
  const ExpenseOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpenseListView(
          context: context,
        ),
      ),
    );
  }
}

class ListEntry extends StatelessWidget {
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
}

class ExpenseListView extends StatelessWidget {
  late final BuildContext context;
  late final Prop<IList<Prop<Expense>>> expenseList;

  ExpenseListView({required this.context, super.key}) {
    expenseList = UserState.of(context).expendList;
  }

  @override
  Widget build(BuildContext context) {
    return $(
        expenseList,
            (expenses) => ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: expenseList.value.length + 1,
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
            var exp = expenseList.value.get(index);
            return ListEntry(expense: exp);
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        ));
  }
}

