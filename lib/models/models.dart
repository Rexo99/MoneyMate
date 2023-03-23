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
