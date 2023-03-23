import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state.dart';

void expenditurePopup(
    {required Prop<Expenditure> expenditure, required BuildContext context}) {
  String name = expenditure.value.name;
  String amount = expenditure.value.amount.toString();
  final formKey = GlobalKey<FormState>();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Edit Expenditure'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: expenditure.value.name,
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
              initialValue: expenditure.value.amount.toString(),
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
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Updated Expenditure')),
              );
              expenditure.value =
                  expenditure.value.setAmount(int.parse(amount));
              expenditure.value = expenditure.value.setName(name);
              Navigator.pop(context, 'OK');
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}