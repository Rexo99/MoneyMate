import 'package:cash_crab/UserState.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state.dart';
import '../util/Formatter.dart';

class test1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: expenditureTable(
          context: context,
        ),
      ),
    );
  }
}

class expenditureTable extends StatelessWidget {
  late BuildContext context;
  late Prop<IList<Prop<Expenditure>>> expendList;

  expenditureTable({required this.context, super.key}) {
    expendList = UserState.of(context).expendList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        $(
          expendList,
          (expenditures) => DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Name',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Amount',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Date',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
            rows: expenditures
                .map(
                  (expenditure) => DataRow(
                    //Todo onLongPress open BottomSheetExample for editing clicked expenditure
                    onLongPress: () =>
                        {popup(expenditure: expenditure, context: context)},
                    cells: <DataCell>[
                      DataCell($(expenditure, (e) => Text(e.name))),
                      DataCell(
                          $(expenditure, (e) => Text(e.amount.toString()))),
                      DataCell(
                          $(expenditure, (e) => Text(dateFormatter(e.date)))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        TextButton(
            onPressed: () => addItem(name: "Döner", amount: 4),
            child: const Text("hallo")),
      ],
    );
  }

  void addItem({
    required String name,
    required int amount,
  }) {
    expendList.value =
        expendList.value.add(Prop(Expenditure(name, amount, DateTime.now())));
  }

  void removeItem(Prop<Expenditure> expenditure) {
    expendList.value = expendList.value.remove(expenditure);
  }

  void updateItem(
      {required Prop<Expenditure> expenditure, String? name, int? amount}) {
    if (name != null) {
      expenditure.value = expenditure.value.setName(name);
    }
    if (amount != null) {
      expenditure.value = expenditure.value.setAmount(amount);
    }
  }
}

void popup(
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
