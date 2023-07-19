import 'dart:convert';
import 'dart:typed_data';
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
  final Uint8List image;

  ExpenseDTO(this.name, this.amount, this.dateTime, this.categoryId, this.image);

  @override
  String toJson() {
    Map<String, dynamic> obj = {
      "name": name,
      "amount": amount,
      "categoryId": categoryId,
      "dateTime": dateTime.toString(),
      "image": image
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

  CategoryDTO(this.name, this.budget, this.userId);

  @override
  String toJson() {
    Map<String, dynamic> obj = {
      "name": name,
      "budget": budget,
      "user_id": userId
    };
    return jsonEncode(obj);
  }
}
