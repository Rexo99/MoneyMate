import 'package:cash_crab/util/HTTPRequestBuilder.dart';
import 'package:flutter/cupertino.dart';

import 'dtos.dart';

abstract class Model {
  Future<int?> get id;

  Model copyWith();

  static Model? fromJson(Map json) {
    return null;
  }
}

@immutable
class Expenditure implements Model {
  @override
  late final Future<int?> id;
  final String name;
  final int amount;
  final DateTime date;

  Expenditure(this.name, this.amount, this.date, categoryId) {
    id = HTTPRequestBuilder().createModel(
        path: "expenditures", tmp: ExpenditureDTO(name, amount, categoryId, date));
  }

  Expenditure._copyWith(this.id, this.name, this.amount, this.date);

  static Expenditure fromJson(Map json) {
    return Expenditure._copyWith(
        json["id"], json["name"], json["amount"], DateTime.parse(json["date"]));
  }

  @override
  Expenditure copyWith({
    String? name,
    int? amount,
  }) =>
      Expenditure._copyWith(
        id,
        name ?? this.name,
        amount ?? this.amount,
        date,
      );

  Expenditure setName(String name) => copyWith(name: name);

  Expenditure setAmount(int amount) => copyWith(amount: amount);
}

/*@immutable
class Category implements Model {
  @override
  final int? id;
  final String name;
  final int budget;
  final int userId;
  final List<Expenditure> expenditureList;

  const Category(
      this.id, this.name, this.budget, this.userId, this.expenditureList);

  static Category fromJson(Map json) {
    return Category(json["id"], json["name"], json["budget"], json["userId"],
        json["expenditureList"]);
  }

  @override
  Category copyWith({
    String? name,
    int? budget,
    List<Expenditure>? expenditureList,
  }) =>
      Category(id ?? this.id, name ?? this.name, budget ?? this.budget, userId,
          expenditureList ?? this.expenditureList);

  Category setName(String name) => copyWith(name: name);

  Category setAmount(int budget) => copyWith(budget: budget);

  Category addExpenditure(Expenditure expenditure) {
    List<Expenditure> expenditures = expenditureList;
    expenditures.add(expenditure);
    return copyWith(expenditureList: expenditures);
  }
}*/
