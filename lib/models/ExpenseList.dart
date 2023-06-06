
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:money_mate/util/DateTimeExtensions.dart';

import '../state.dart';
import '../util/HTTPRequestBuilder.dart';
import 'dtos.dart';
import 'models.dart';

class ExpenseList extends Prop<IList<Prop<Expense>>> {
  ExpenseList(super.value);


  //Creates an Expense and adds it to the [expendList]
  void addExpense({
    required String name,
    required int amount,
    required int categoryId
  }) {
    value = value
        .add(Prop(Expense(name, amount, DateTime.now(), categoryId)));
  }

  void updateItem({required Prop<Expense> expense, String? name, int? amount}) {
    if (name != null) {
      expense.value = expense.value.setName(name);
    }
    if (amount != null) {
      expense.value = expense.value.setAmount(amount);
    }
    HTTPRequestBuilder().put(
        path: "expenditures/${expense.value.id}",
        obj: ExpenseDTO(expense.value.name, expense.value.amount,
            expense.value.date, expense.value.categoryId),
        returnType: Expense);
  }

  void removeItem(Prop<Expense> expense) {
    value = value.remove(expense);
    HTTPRequestBuilder().delete(deleteType: Expense, objId: expense.value.id);
  }

  double getTotalToday(){
    double total = 0;
    for (var expense in value) {
      if(expense.value.date.isToday()){
        total += expense.value.amount;
      }
    }
    return total;
  }
  double getTotalMonth(){
    double total = 0;
    for (var expense in value) {
      if(expense.value.date.inMonth()){
        total += expense.value.amount;
      }
    }
    return total;
  }

  //clears the expendList and fills it with fresh data from the backend
  Future<void> initListExpenseList() async {
    value = value.clear();
    List<Expense> exps = (await HTTPRequestBuilder().get(
        path: "expenditures", //todo - change to "expenses"
        returnType: List<Expense>)) as List<Expense>;
    for (Expense element in exps) {
      value = value.add(Prop(element));
    }
  }

  /// Sorts the list of DateTimes in descending order and returns the [count] newest DateTimes
  IList<Prop<Expense>> findNewest(int count) {
    if (value.isEmpty) {
      return value;
      //throw Exception('The list of DateTimes is empty.');
    }

    //expenseList.value.sort(); // Sort in descending order
    value.sortOrdered((a, b) => a.value.date.compareTo(b.value.date));

    if (count > value.length) {
      count = value.length; // Adjust count if it exceeds the number of available DateTimes
    }

    return value.sublist(0, count);
  }

}