
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
  }) {
    value = value
        .add(Prop(Expense(name, amount, DateTime.now(), 1)));
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
    value.clear();
    List<Expense> exps = (await HTTPRequestBuilder().get(
        path: "expenditures", //todo - change to "expenses"
        returnType: List<Expense>)) as List<Expense>;
    for (Expense element in exps) {
      value = value.add(Prop(element));
    }
  }

}