class Expenditure {
  String name;
  int amount;
  late final DateTime date;

  Expenditure(this.name, this.amount) {
    date = DateTime.now();
  }
}