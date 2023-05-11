import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/UserState.dart';
import '../main.dart';
import '../models/models.dart';
import '../state.dart';

void expensePopup(
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
              initialValue: expense.value.amount.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                } else if (int.tryParse(value) == null) {
                  return "Please enter a valid number";
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

//not in use, code stays here until color is 100% sorted out though
  void colorPicker({required BuildContext context}) {
    List <bool> _selection = List.generate(4, (index) => false);
    List <Color> _colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

    showDialog<String>(
      context: context,
      builder: (BuildContext subContext) =>
          AlertDialog(
            title: const Text('Color Picker'),
            content: Center(
                child:
                ToggleButtons(
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: _colors[0],
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.grey.shade300)),
                        child: const Center(
                            child: Text('Red')
                        )
                    ),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: _colors[1],
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.grey.shade300)),
                        child: const Center(
                            child: Text('Green')
                        )
                    ),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: _colors[2],
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.grey.shade300)),
                        child: const Center(
                            child: Text('Blue')
                        )
                    ),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: _colors[3],
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.grey.shade300)),
                        child: const Center(
                            child: Text('Yellow')
                        )
                    ),
                  ],
                  isSelected: _selection,
                  borderColor: Colors.transparent,

                  onPressed: (int index) {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selection.length; i++) {
                      _selection[i] = i == index;
                    }
                  },

            ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(subContext, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  for (int i = 0; i < _selection.length; i++) {
                    if (_selection[i] == true) {
                      MyApp.of(context).changeThemeColor(_colors[i]);
                    }
                  }
                  Navigator.pop(subContext, 'Confirm');
                },
                child: const Text('Confirm'),
              ),
            ],
          ),

    );
  }

  //todo - make colors work in dark mode
void colorPicker2({required BuildContext context}) {
  List <bool> _selection = List.generate(4, (index) => false);
  List <Color> _colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
  List <Color> _DesiredColors = [Colors.amber, Color.fromARGB(100, 253, 112, 165), Color.fromARGB(100, 50, 113, 60), Colors.teal];

  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) =>
        AlertDialog(
          title: const Text('Color Picker'),
          content: Expanded(
            child: Wrap(
              children: [
                /*
              GestureDetector(child: Container(color: testColor, width: 50, height: 50), onTap: () {
                for (int i = 0; i < _selection.length; i++) {
                  _selection[i] = i == 0;
                }
                testColor = Color(_colors[0] as int).withBlue(80);
              }
              ),

                 */
              FilledButton(
                  onPressed: () {
                    for (int i = 0; i < _selection.length; i++) {
                      _selection[i] = i == 0;
                    }
                  }, child: Text('Red'), style: FilledButton.styleFrom(backgroundColor: _colors[0], shape: CircleBorder())),
                FilledButton(
                    onPressed: () {
                      for (int i = 0; i < _selection.length; i++) {
                        _selection[i] = i == 1;
                      }
                    }, child: Text('Green'), style: FilledButton.styleFrom(backgroundColor: _colors[1], shape: CircleBorder())),
                FilledButton(
                    onPressed: () {
                      for (int i = 0; i < _selection.length; i++) {
                        _selection[i] = i == 2;
                      }
                    }, child: Text('Blue'), style: FilledButton.styleFrom(backgroundColor: _colors[2], shape: CircleBorder())),
              FilledButton(onPressed: () {
                for (int i = 0; i < _selection.length; i++) {
                  _selection[i] = i == 3;
                }
              }, child: Text('Yellow'), style: FilledButton.styleFrom(backgroundColor: _colors[3], shape: CircleBorder())),]
            ),
            ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(subContext, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                for (int i = 0; i < _selection.length; i++) {
                  if (_selection[i] == true) {
                    MyApp.of(context).changeThemeColor(_colors[i]);
                  }
                }
                Navigator.pop(subContext, 'Confirm');
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
  );
}