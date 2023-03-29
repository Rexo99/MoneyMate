import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'models.dart';

abstract class DTO {
  String get name;

  String toJson();
}

@immutable
class ExpenditureDTO extends DTO {
  @override
  final String name;
  final int amount;
  final int categoryId;
  final DateTime dateTime;

  ExpenditureDTO(this.name, this.amount, this.categoryId, this.dateTime);

  @override
  String toJson() {
    Map<String, dynamic> obj = {
      "name": name,
      "amount": amount,
      "categoryId": categoryId,
      "dateTime": dateTime.toString()
    };
    return jsonEncode(obj);
  }
}

@immutable
class CategoryDTO extends DTO {
  @override
  final String name;
  final int budget;
  final int userId;
  final List<Expenditure> expenditureList;

  CategoryDTO(this.name, this.budget, this.userId, this.expenditureList);

  @override
  String toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}
