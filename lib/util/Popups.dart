import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/UserState.dart';
import '../models/models.dart';
import '../state.dart';

void updateExpensePopup(
    {required Prop<Expense> expense, required BuildContext context}) {
  String name = expense.value.name;
  String amount = expense.value.amount.toString();
  final formKey = GlobalKey<FormState>();
  showDialog<String>(
    context: context,
    builder: (BuildContext subcontext) => AlertDialog(
      title: const Text('Edit Expense'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.shopping_cart),
                labelText: 'Name',
              ),
              initialValue: expense.value.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  name = value;
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.euro),
                labelText: 'Amount',
              ),
              initialValue: expense.value.amount.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pleas enter a number';
                } else if (int.tryParse(value) == null) {
                  return "Pleas enter a valid number";
                } else {
                  amount = value;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(subcontext, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(subcontext).showSnackBar(
                const SnackBar(content: Text('Updated Expense')),
              );
              //Todo not the right context?
              UserState.of(context).updateItem(
                  expense: expense,
                  name: name,
                  amount: int.parse(amount));
              Navigator.pop(subcontext, 'OK');
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void createExpensePopup({ required BuildContext context}){
  String name = "";
  String amount = "";
  final formKey = GlobalKey<FormState>();
  showDialog<String>(
    context: context,
    builder: (BuildContext subcontext) => AlertDialog(
      title: const Text('Edit Expense'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.shopping_cart),
                hintText: 'Name of your Expense?',
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  name = value;
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.euro),
                hintText: 'Amount of your Expense',
                labelText: 'Amount',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pleas enter a number';
                } else if (int.tryParse(value) == null) {
                  return "Pleas enter a valid number";
                } else {
                  amount = value;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(subcontext, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(subcontext).showSnackBar(
                const SnackBar(content: Text('Created Expense')),
              );
              UserState.of(context).addItem(
                  name: name,
                  amount: int.parse(amount));
              Navigator.pop(subcontext, 'OK');
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void infoPopup(
    {required List featureList, required BuildContext context}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
      title: const Text('Implemented Features'),
      content: Column(
        children: [...featureList],
        mainAxisSize: MainAxisSize.min,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(subContext, 'Cancel'),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
