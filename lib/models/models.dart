import 'package:flutter/cupertino.dart';

@immutable
class Expenditure {
  final String name;
  final int amount;
  final DateTime date;

  const Expenditure(this.name, this.amount, this.date);

  Expenditure copyWith({
    String? name,
    int? amount,
  }) =>
      Expenditure(
        name ?? this.name,
        amount ?? this.amount,
        date,
      );

  Expenditure setName(String name) => copyWith(name: name);

  Expenditure setAmount(int amount) => copyWith(amount: amount);
}

@immutable
class Category {
  final String name;
  final int budget;
  final int userId;
  final List<Expenditure> expenditureList;

  const Category(this.name, this.budget, this.userId, this.expenditureList);

  Category copyWith({
    String? name,
    int? budget,
    List<Expenditure>? expenditureList,
  }) =>
      Category(name ?? this.name, budget ?? this.budget, userId,
          expenditureList?? this.expenditureList);

  Category setName(String name) => copyWith(name: name);

  Category setAmount(int budget) => copyWith(budget: budget);

  Category addExpenditure(Expenditure expenditure) {
    List<Expenditure> expenditures = expenditureList;
    expenditures.add(expenditure);
    return copyWith(expenditureList: expenditures);
  }
}
