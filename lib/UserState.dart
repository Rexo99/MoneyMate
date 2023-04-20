import 'dart:convert';


import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_mate/state.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';

import 'models/models.dart';

class UserState extends InheritedWidget {
  UserState({super.key, required super.child});

  late final HTTPRequestBuilder builder = HTTPRequestBuilder();


  //Prop<IList<Prop<Category>>> categoryList = Prop(<Prop<Category>>[].lockUnsafe);
  Prop<IList<Prop<Expenditure>>> expendList = Prop(<Prop<Expenditure>>[].lockUnsafe);


  static UserState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserState>();

  static UserState of(BuildContext context) {
    final UserState? result = maybeOf(context);
    assert(result != null, 'No UserState found in context');
    return result!;
  }

  void addItem({
    required String name,
    required int amount,
  }) {
    expendList.value = expendList.value
        .add(Prop(Expenditure(name, amount, DateTime.now(), 1)));
  }


  @override
  bool updateShouldNotify(covariant UserState oldWidget) {
    return builder != oldWidget.builder;
  }
}
