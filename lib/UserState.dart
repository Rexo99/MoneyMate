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
  Prop<IList<Prop<Expenditure>>> expendList =
      Prop(<Prop<Expenditure>>[].lockUnsafe);

  static UserState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserState>();

  static UserState of(BuildContext context) {
    final UserState? result = maybeOf(context);
    assert(result != null, 'No UserState found in context');
    return result!;
  }

  //clears the expendList and fills it with fresh data from the backend
  Future<void> initListExpenditureList() async {
    expendList.value.clear();
    List<Expenditure> exps = (await HTTPRequestBuilder().get(
        path: "expenditures",
        returnType: List<Expenditure>)) as List<Expenditure>;
    for (Expenditure element in exps) {
      expendList.value = expendList.value.add(Prop(element));
    }
  }

  //Create an Expenditure and adds it to the [expendList]
  void addItem({
    required String name,
    required int amount,
  }) {
    expendList.value = expendList.value
        .add(Prop(Expenditure(name, amount, DateTime.now(), 1)));
    //Todo api call
  }

  void removeItem(Prop<Expenditure> expenditure) {
    expendList.value = expendList.value.remove(expenditure);
    //Todo api call
  }

  void updateItem(
      {required Prop<Expenditure> expenditure, String? name, int? amount}) {
    if (name != null) {
      expenditure.value = expenditure.value.setName(name);
    }
    if (amount != null) {
      expenditure.value = expenditure.value.setAmount(amount);
    }
    HTTPRequestBuilder().put(
        path: "expenditures/${expenditure.value.id}",
        obj: ExpenditureDTO(expenditure.value.name, expenditure.value.amount,
            expenditure.value.date, expenditure.value.categoryId),
        returnType: Expenditure);
  }

  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return builder != oldWidget.builder;
  }
}
