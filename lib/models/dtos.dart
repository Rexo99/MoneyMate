import 'dart:convert';

abstract class DTO {
  String get name;

  String toJson();
}

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
