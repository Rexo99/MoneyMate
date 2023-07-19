import 'dart:convert';
import 'dart:typed_data';

import '../util/HTTPRequestBuilder.dart';
import 'dtos.dart';

abstract class Model{
  int? _id;

  get id => _id;

  Model copyWith();

  static Model? fromJson(Map json) {
    return null;
  }
}

class Expense implements Model {
  @override
  int? _id;

  @override
  int? get id => _id;
  final String name;
  final num amount;
  final DateTime date;
  final int categoryId;
  final Uint8List image;

  Expense(this.name, this.amount, this.date, this.categoryId, this.image) {
    HTTPRequestBuilder()
        .createModel(
            path: "expenditures",
            tmp: ExpenseDTO(name, amount, date, categoryId, image))
        .then((value) => _id = value);
  }

  Expense._(this._id, this.name, this.amount, this.date, this.categoryId, this.image);

  static Expense fromJson(Map json) {
    return Expense._(json["id"], json["name"], json["amount"],
        DateTime.parse(json["dateTime"]), json["categoryId"], json["image"]);
  }

  @override
  Expense copyWith({
    String? name,
    num? amount,
    Uint8List? image,
  }) =>
      Expense._(
          id, name ?? this.name, amount ?? this.amount, date, categoryId, image ?? this.image);

  Expense setName(String name) => copyWith(name: name);

  Expense setAmount(num amount) => copyWith(amount: amount);

  Expense setImage(Uint8List image) => copyWith(image: image);
}

class Category implements Model {
  @override
  int? _id;

  @override
  int? get id => _id;
  final String name;
  final int budget;
  int? userId;

  Category(
      this._id, this.name, this.budget, this.userId) {
    HTTPRequestBuilder()
        .createModel(
            path: "categories",
            tmp: CategoryDTO(name, budget, userId))
        .then((value) => _id = value);
  }

  Category.create(this.name, this.budget);

  Category._(
      this._id, this.name, this.budget, this.userId);

  static Category fromJson(Map json) {
    return Category._(json["id"], json["name"], json["budget"], json["user_id"]);
  }

  create() async {
    await HTTPRequestBuilder()
        .createModel(
        path: "categories",
        tmp: CategoryDTO(name, budget, userId))
        .then((value) => _id = value);
  }

  @override
  Category copyWith({
    String? name,
    int? budget,
  }) =>
      Category._(_id, name ?? this.name, budget ?? this.budget, userId);

  Category setName(String name) => copyWith(name: name);

  Category setBudget(int budget) => copyWith(budget: budget);

/*  Category addExpenditure(Expense expenditure) {
    List<Expense> expenditures = expenditureList;
    expenditures.add(expenditure);
    return copyWith(expenditureList: expenditures);
  }*/
}
