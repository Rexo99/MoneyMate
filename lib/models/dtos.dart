import 'dart:convert';
import 'package:flutter/cupertino.dart';

abstract class DTO {
  String get name;

  String toJson();
}

@immutable
class ExpenseDTO extends DTO {
  @override
  final String name;
  final num amount;
  final int categoryId;
  final DateTime dateTime;
  final int? imageId;

  ExpenseDTO(this.name, this.amount, this.dateTime, this.categoryId, this.imageId);

  @override
  String toJson() {
    Map<String, dynamic> obj = {
      "name": name,
      "amount": amount,
      "categoryId": categoryId,
      "dateTime": dateTime.toString(),
      "imageId": imageId
    };
    return jsonEncode(obj);
  }
}

@immutable
class CategoryDTO extends DTO {
  @override
  final String name;
  final int budget;
  int? userId;
  String? icon;

  CategoryDTO(this.name, this.budget, this.userId, this.icon);

  @override
  String toJson() {
    Map<String, dynamic> obj = {
      "name": name,
      "budget": budget,
      "user_id": userId,
      "icon": icon
    };
    return jsonEncode(obj);
  }
}