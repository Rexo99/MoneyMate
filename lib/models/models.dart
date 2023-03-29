import 'package:cash_crab/util/HTTPRequestBuilder.dart';
import 'dtos.dart';

abstract class Model {
  int? _id;

  get id => _id;

  Model copyWith();

  static Model? fromJson(Map json) {
    return null;
  }
}

class Expenditure implements Model {
  @override
  int? _id;

  @override
  int? get id => _id;
  final String name;
  final int amount;
  final DateTime date;

  Expenditure(this.name, this.amount, this.date, categoryId) {
    HTTPRequestBuilder()
        .createModel(
            path: "expenditures",
            tmp: ExpenditureDTO(name, amount, categoryId, date))
        .then((value) => _id = value);
  }

  Expenditure._(this._id, this.name, this.amount, this.date);

  static Expenditure fromJson(Map json) {
    return Expenditure._(
        json["id"], json["name"], json["amount"], DateTime.parse(json["date"]));
  }

  @override
  Expenditure copyWith({
    String? name,
    int? amount,
  }) =>
      Expenditure._(
        id,
        name ?? this.name,
        amount ?? this.amount,
        date,
      );

  Expenditure setName(String name) => copyWith(name: name);

  Expenditure setAmount(int amount) => copyWith(amount: amount);
}

class Category implements Model {
  @override
  int? _id;

  @override
  get id => _id;
  final String name;
  final int budget;
  final int userId;
  final List<Expenditure> expenditureList;

  Category(
      this._id, this.name, this.budget, this.userId, this.expenditureList) {
    HTTPRequestBuilder()
        .createModel(
            path: "expenditures",
            tmp: CategoryDTO(name, budget, userId, expenditureList))
        .then((value) => _id = value);
  }

  Category._(
      this._id, this.name, this.budget, this.userId, this.expenditureList);

  static Category fromJson(Map json) {
    return Category._(json["id"], json["name"], json["budget"], json["userId"],
        json["expenditureList"]);
  }

  @override
  Category copyWith({
    String? name,
    int? budget,
    List<Expenditure>? expenditureList,
  }) =>
      Category._(
          _id,
          name ?? this.name,
          budget ?? this.budget,
          userId,
          expenditureList ?? this.expenditureList
      );

  Category setName(String name) => copyWith(name: name);

  Category setBudget(int budget) => copyWith(budget: budget);

  Category addExpenditure(Expenditure expenditure) {
    List<Expenditure> expenditures = expenditureList;
    expenditures.add(expenditure);
    return copyWith(expenditureList: expenditures);
  }
}
