import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/models/ExpenseList.dart';
import 'package:money_mate/pages/Homepage.dart';
import 'package:money_mate/util/DateTimeExtensions.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
import '../util/Popups.dart';

class ExpenseOverview extends StatefulWidget {
  const ExpenseOverview({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseOverview();
}

class _ExpenseOverview extends State<ExpenseOverview> {
  late ExpenseList allItems;
  var items = [];
  var searchHistory = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(queryListener);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(queryListener);
    searchController.dispose();
  }

  void queryListener() {
    search(searchController.text);
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        items = allItems.value.toList();
      });
    } else {
      setState(() {
        items = allItems.value
            .where(
                (e) => e.value.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpenseListView(
          context: context,
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    allItems = UserState.of(context).expendList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: SearchBar(
                leading: const Icon(Icons.search),
                controller: searchController,
                hintText: "Search...",
              ),),
              Expanded(
                  child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.isEmpty ? allItems.value.length : items.length,
                itemBuilder: (context, index) {
                  Prop<Expense> item =
                      items.isEmpty ? allItems.value[index] : items[index];
                  return $(item, (p1) => ExpenseCard(
                    expense: item,
                    index: index,
                    context: context,
                  ));
                },
              )),

              /*$(
                  UserState.of(context).expendList,
                  (p0) => CardListBuilder(
                      objectList: UserState.of(context).expendList,
                      cardType: Expense,
                      count: 20)),*/
            ],
          ),
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
