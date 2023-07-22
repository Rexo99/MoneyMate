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

///
///
class Expense implements Model {
  @override
  int? _id;

  @override
  int? get id => _id;
  final String name;
  final num amount;
  final DateTime date;
  final int categoryId;

  Expense(this.name, this.amount, this.date, this.categoryId) {
    HTTPRequestBuilder()
        .createModel(
        path: "expenditures",
        tmp: ExpenseDTO(name, amount, date, categoryId))
        .then((value) => _id = value);
  }

  Expense._(this._id, this.name, this.amount, this.date, this.categoryId);

  static Expense fromJson(Map json) {
    return Expense._(json["id"], json["name"], json["amount"],
        DateTime.parse(json["dateTime"]), json["categoryId"]);
  }

  @override
  Expense copyWith({
    String? name,
    num? amount,
  }) =>
      Expense._(
          id, name ?? this.name, amount ?? this.amount, date, categoryId);

  Expense setName(String name) => copyWith(name: name);

  Expense setAmount(num amount) => copyWith(amount: amount);
}

class Category implements Model {
  @override
  int? _id;

  @override
  int? get id => _id;
  final String name;
  final int budget;
  int? userId;
  String? icon;

  Category(
      this._id, this.name, this.budget, this.userId, this.icon) {
    HTTPRequestBuilder()
        .createModel(
        path: "categories",
        tmp: CategoryDTO(name, budget, userId, icon))
        .then((value) => _id = value);
  }

  Category.create(this.name, this.budget, this.icon);

  Category._(
      this._id, this.name, this.budget, this.userId, this.icon);

  static Category fromJson(Map json) {
    print(json["icon"]);
    print(json["name"]);
    return Category._(json["id"], json["name"], json["budget"], json["user_id"], json["icon"]);
  }

  create() async {
    await HTTPRequestBuilder()
        .createModel(
        path: "categories",
        tmp: CategoryDTO(name, budget, userId, icon))
        .then((value) => _id = value);
  }

  @override
  Category copyWith({
    String? name,
    int? budget,
    String? icon,
  }) =>
      Category._(_id, name ?? this.name, budget ?? this.budget, userId, icon ?? this.icon);

  Category setName(String name) => copyWith(name: name);

  Category setBudget(int budget) => copyWith(budget: budget);

  Category setIcon(String icon) => copyWith(icon: icon);

/*  Category addExpenditure(Expense expenditure) {
    List<Expense> expenditures = expenditureList;
    expenditures.add(expenditure);
    return copyWith(expenditureList: expenditures);
  }*/
}