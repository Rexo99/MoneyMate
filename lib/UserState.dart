import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_mate/state.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';

import 'models/dtos.dart';
import 'models/models.dart';

class UserState extends InheritedWidget {
  UserState({super.key, required super.child});

  late final HTTPRequestBuilder builder = HTTPRequestBuilder();

  //Prop<IList<Prop<Category>>> categoryList = Prop(<Prop<Category>>[].lockUnsafe);
  Prop<IList<Prop<Expense>>> expendList = Prop(<Prop<Expense>>[].lockUnsafe);

  static UserState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserState>();

  static UserState of(BuildContext context) {
    final UserState? result = maybeOf(context);
    assert(result != null, 'No UserState found in context');
    return result!;
  }

  //clears the expendList and fills it with fresh data from the backend
  Future<void> initListExpenseList() async {
    expendList.value.clear();
    List<Expense> exps = (await HTTPRequestBuilder().get(
        path: "expenditures", //todo - change to "expenses"
        returnType: List<Expense>)) as List<Expense>;
    for (Expense element in exps) {
      expendList.value = expendList.value.add(Prop(element));
    }
  }

  void loginUser({
    required String name,
    required String password,
  }) async {
    await HTTPRequestBuilder().login(name: name, password: password);
  }

  void registerUser({
    required String name,
    required String password,
  }) async {
    await HTTPRequestBuilder().register(name: name, password: password);
  }

  //Create an Expenditure and adds it to the [expendList]
  void addItem({
    required String name,
    required int amount,
  }) {
    expendList.value =
        expendList.value.add(Prop(Expense(name, amount, DateTime.now(), 1)));
    //Todo api call
  }

  void removeItem(Prop<Expense> expense) {
    expendList.value = expendList.value.remove(expense);
    //Todo api call
  }

  void updateItem({required Prop<Expense> expense, String? name, int? amount}) {
    if (name != null) {
      expense.value = expense.value.setName(name);
    }
    if (amount != null) {
      expense.value = expense.value.setAmount(amount);
    }
    HTTPRequestBuilder().put(
        path: "expenditures/${expense.value.id}",
        obj: ExpenseDTO(expense.value.name, expense.value.amount,
            expense.value.date, expense.value.categoryId),
        returnType: Expense);
  }

  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return builder != oldWidget.builder;
  }
}
