import 'package:flutter/material.dart';
import 'package:money_mate/models/ExpenseList.dart';
import 'package:money_mate/pages/Homepage.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../util/StateManagement.dart';

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

  @override
  Widget build(BuildContext context) {
    allItems = UserState.of(context).expendList;
    //Todo hier nach category iterieren
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
            ],
          ),
        ),
      ),
    );
  }
}