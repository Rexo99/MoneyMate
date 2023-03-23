import 'package:cash_crab/UserState.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state.dart';
import '../util/Formatter.dart';
import '../util/Popups.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpenditureTable(
          context: context,
        ),
      ),
    );
  }
}

class ExpenditureTable extends StatelessWidget {
  late final BuildContext context;
  late final Prop<IList<Prop<Expenditure>>> expendList;

  ExpenditureTable({required this.context, super.key}) {
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
                    onLongPress: () =>
                        {expenditurePopup(expenditure: expenditure, context: context)},
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

