
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/models/ExpenseList.dart';
import 'package:money_mate/pages/Homepage.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../util/StateManagement.dart';

class CatExpense extends StatefulWidget {
  CatExpense({super.key, required this.category});
  Category category;

  @override
  State<StatefulWidget> createState() => _CatExpenseOverview(category: category);
}

class _CatExpenseOverview extends State<CatExpense> {
  _CatExpenseOverview({required this.category});
  late ExpenseList allItems;
  Category category;
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

  ExpenseList getCatExpense(ExpenseList exp) {
    ExpenseList newexp = ExpenseList(<Prop<Expense>>[].lockUnsafe);
    for (Prop<Expense> expense in exp.value) {
      if ( expense.value.categoryId == category.id) {
        newexp.value = newexp.value.add(expense);
      }
    }
    print(category.id);
    return newexp;
  }

  /// Code by Erik Hinkelmanns
  // ExpenseList getCatExpense(ExpenseList exp, int? categoryid) {
  //   ExpenseList newexp = ExpenseList(<Prop<Expense>>[].lockUnsafe);
  //   for (Prop<Expense> expense in exp.value) {
  //     if ( expense.value.categoryId == categoryid) {
  //       newexp.value.add(expense);
  //     }
  //   }
  //   return newexp;
  // }

  @override
  Widget build(BuildContext context,) {
    // int? categoryid = category.id;
    allItems = getCatExpense(UserState.of(context).expendList);
    print(allItems);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
