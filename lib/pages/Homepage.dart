import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
import '../util/Formatter.dart';
import '../util/Popups.dart';
import 'ExpenseOverview.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          HTTPRequestBuilder().getLoginState()
          ? CardListBuilder(objectList: UserState.of(context).expendList, cardType: Expense, count: 3)
          : Text("Please login"),
          ElevatedButton(
              onPressed: () => print("unimplemented"),
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseOverview())),
              child: const Text("See All")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [TotalExpense("Today"), TotalExpense("Month")],
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
class CardListBuilder <T extends Prop<IList>> extends StatelessWidget {
  T objectList;
  Type cardType;
  int count = 3;

  CardListBuilder({required this.objectList, required this.cardType, required this.count,super.key});

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
                  ValueNotifier<Expense>? expense = objectList.value.getOrNull(index);
                  print("Homepage: ${UserState.of(context).expendList.value.length}"); //Todo remove
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
  String title = "none";

  TotalExpense(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "__",
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
