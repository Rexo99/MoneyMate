import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

/// Model for expenses
/// Code by Erik Hinkelmanns, Dannie Krösche, Dorian Zimmermann
class Expense implements Model {
  @override
  int? _id;

  @override
  int? get id => _id;
  final String name;
  final num amount;
  final DateTime date;
  final int categoryId;
  final int? imageId;

  Expense(this.name, this.amount, this.date, this.categoryId, this.imageId) {
    HTTPRequestBuilder()
        .createModel(
        path: "expenditures",
        tmp: ExpenseDTO(name, amount, date, categoryId, imageId))
        .then((value) => _id = value);
  }

  Expense._(this._id, this.name, this.amount, this.date, this.categoryId, this.imageId);

  static Expense fromJson(Map json) {
    return Expense._(json["id"], json["name"], json["amount"],
        DateTime.parse(json["dateTime"]), json["categoryId"], json["imageId"]);
  }

  @override
  Expense copyWith({
    String? name,
    num? amount,
    int? imageId,
  }) =>
      Expense._(
          id, name ?? this.name, amount ?? this.amount, date, categoryId, imageId ?? this.imageId);

  Expense setName(String name) => copyWith(name: name);

  Expense setAmount(num amount) => copyWith(amount: amount);

  Expense setImage(int imageId) => copyWith(imageId: imageId);
}

/// Model for categories
/// Code by Erik Hinkelmanns, Dannie Krösche, Dorian Zimmermann, Daniel Ottolien
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
    print(json["name"] + " IconName: " + json["icon"]);
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

  /// Returns the IconData for the icon name
  /// Code by Erik Hinkelmanns
  IconData getIconData(){
      switch(icon) {
        case '':
          return Icons.square;
        case 'home':
          return Icons.home;
        case 'car_repair':
          return Icons.car_repair;
        case 'local_grocery_store':
          return Icons.local_grocery_store;
        case 'local_bar':
          return Icons.local_bar;
        case 'flight':
          return Icons.flight;
        case 'business':
          return Icons.business;
        case 'album':
          return Icons.album;
        case 'pets':
          return Icons.pets;
        default:
          return Icons.square;
      }
  }
}