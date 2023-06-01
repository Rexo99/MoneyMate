import 'dart:core';
import 'package:flutter/material.dart';
import 'package:money_mate/UserState.dart';
import '../main.dart';
import '../models/models.dart';
import '../state.dart';

void updateExpensePopup(
    {required Prop<Expense> expense, required BuildContext context}) {
  String name = expense.value.name;
  String amount = expense.value.amount.toString();
  final formKey = GlobalKey<FormState>();
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
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
          onPressed: () => Navigator.pop(subContext, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(subContext).showSnackBar(
                const SnackBar(content: Text('Updated Expense')),
              );
              //Todo not the right context?
              UserState.of(context).expendList.updateItem(
                  expense: expense, name: name, amount: int.parse(amount));
              Navigator.pop(subContext, 'OK');
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void createExpensePopup({required BuildContext context}) {
  String name = "";
  String amount = "";
  late int categoryId;
  final formKey = GlobalKey<FormState>();
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
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
            DropdownButtonFormField<Category>(
              items: UserState.of(context)
                  .categoryList
                  .map<DropdownMenuItem<Category>>((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (selectedCategory) {
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.category),
                hintText: 'Category of your Expense',
                labelText: 'Category',
              ),
              validator: (value) {
                if (value == null || value.id == null) {
                  return 'Pleas choose a category';
                }
                categoryId = value.id!;
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(subContext, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ScaffoldMessenger.of(subContext).showSnackBar(
                const SnackBar(content: Text('Created Expense')),
              );
              UserState.of(context).expendList.addExpense(
                  name: name,
                  amount: int.parse(amount),
                  categoryId: categoryId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Hud()));
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void DeleteCategoryPopup({ required Category category, required BuildContext context}){
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) =>
        AlertDialog(
          title: const Text('Kategorie löschen'),
          content: const Text('Alle in der Kategorie gespeicherten Daten werden gelöscht'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Abbrechen'),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                // UserState.of(context).removeCategory(category);
                // UserState.of(context).removeCategory(UserState.of(context).categoryList.last);
                UserState.of(context).removeCategory(category);
                  Navigator.pop(subContext, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
  );
}



void infoPopup({required List featureList, required BuildContext context}) {
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

void colorPicker(
    {required Color currentColor,
    required ThemeMode currentThemeMode,
    required BuildContext context}) {
  List<Color> _colors = [
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.brown
  ];
  final List<bool> _selection = <bool>[
    false,
    false,
    true
  ]; //List for switching app design //todo - load user settings for app design mode (system mode is standard)
  //List <Color> _DesiredColors = [Colors.amber, Color.fromARGB(100, 253, 112, 165), Color.fromARGB(100, 50, 113, 60), Colors.teal]; //todo - create custom color palette

  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) =>
        AlertDialog(
          title: const Text('Theme Settings'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 25),
                Text('Choose your Theme Color', textAlign: TextAlign.center),
                SizedBox(height: 10),
                //todo - find a way to highlight the selected button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                        onPressed: () => MyApp.of(context).changeThemeColor(_colors[0]),
                        child: Text('Red', textScaleFactor: .9), style: FilledButton.styleFrom(backgroundColor: _colors[0], shape: CircleBorder())),
                    FilledButton(
                        onPressed: () => MyApp.of(context).changeThemeColor(_colors[1]),
                        child: Text('Purple', textScaleFactor: .9), style: FilledButton.styleFrom(backgroundColor: _colors[1], shape: CircleBorder())
                    ),
                    FilledButton(
                        onPressed: () => MyApp.of(context).changeThemeColor(_colors[2]),
                        child: Text('Blue', textScaleFactor: .9), style: FilledButton.styleFrom(backgroundColor: _colors[2], shape: CircleBorder())
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                        onPressed: () => MyApp.of(context).changeThemeColor(_colors[3]),
                        child: Text('Green', textScaleFactor: .9), style: FilledButton.styleFrom(backgroundColor: _colors[3], shape: CircleBorder())),
                    FilledButton(
                        onPressed: () => MyApp.of(context).changeThemeColor(_colors[4]),
                        child: Text('Yellow', textScaleFactor: .9), style: FilledButton.styleFrom(backgroundColor: _colors[4], shape: CircleBorder())),
                    FilledButton(
                        onPressed: () => MyApp.of(context).changeThemeColor(_colors[5]),
                        child: Text('Brown', textScaleFactor: .9), style: FilledButton.styleFrom(backgroundColor: _colors[5], shape: CircleBorder())),
                  ],
                ),
                SizedBox(height: 25),
                Divider(),
                SizedBox(height: 25),
                Text('Choose your Theme Mode', textAlign: TextAlign.center),
                SizedBox(height: 10),
                Center(
                    child: ToggleButtons(
                      children: [Icon(Icons.light_mode), Icon(Icons.dark_mode), Icon(Icons.app_shortcut)],
                      isSelected: _selection,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onPressed: (int index) {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _selection.length; i++) {
                          _selection[i] = i == index;
                        }
                        switch(index){
                          case 0: MyApp.of(context).changeTheme(ThemeMode.light);
                          break;
                          case 1: MyApp.of(context).changeTheme(ThemeMode.dark);
                          break;
                          case 2: MyApp.of(context).changeTheme(ThemeMode.system);
                          break;
                        }
                      },
                    )
                ),
                SizedBox(height: 25),
            ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                MyApp.of(context).changeThemeColor(currentColor);
                MyApp.of(context).changeTheme(currentThemeMode);
                Navigator.pop(subContext, 'Cancel');},
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //todo - maybe save chosen color to account here?
                Navigator.pop(subContext, 'Confirm');
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
  );
}

//Just the colorPicker, nothing else:
void colorPicker2(
    {required Color currentColor, required BuildContext context}) {
  List<Color> _colors = [
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.brown
  ];
  //List <Color> _DesiredColors = [Colors.amber, Color.fromARGB(100, 253, 112, 165), Color.fromARGB(100, 50, 113, 60), Colors.teal]; //todo - create custom color palette

  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
      title: const Text('Color Picker'),
      content: Expanded(
        child: Wrap(alignment: WrapAlignment.center, children: [
          FilledButton(
              onPressed: () => MyApp.of(context).changeThemeColor(_colors[0]),
              child: Text('Red', textScaleFactor: .9),
              style: FilledButton.styleFrom(
                  backgroundColor: _colors[0], shape: CircleBorder())),
          FilledButton(
              onPressed: () => MyApp.of(context).changeThemeColor(_colors[1]),
              child: Text('Purple', textScaleFactor: .9),
              style: FilledButton.styleFrom(
                  backgroundColor: _colors[1], shape: CircleBorder())),
          FilledButton(
              onPressed: () => MyApp.of(context).changeThemeColor(_colors[2]),
              child: Text('Blue', textScaleFactor: .9),
              style: FilledButton.styleFrom(
                  backgroundColor: _colors[2], shape: CircleBorder())),
          FilledButton(
              onPressed: () => MyApp.of(context).changeThemeColor(_colors[3]),
              child: Text('Green', textScaleFactor: .9),
              style: FilledButton.styleFrom(
                  backgroundColor: _colors[3], shape: CircleBorder())),
          FilledButton(
              onPressed: () => MyApp.of(context).changeThemeColor(_colors[4]),
              child: Text('Yellow', textScaleFactor: .9),
              style: FilledButton.styleFrom(
                  backgroundColor: _colors[4], shape: CircleBorder())),
          FilledButton(
              onPressed: () => MyApp.of(context).changeThemeColor(_colors[5]),
              child: Text('Brown', textScaleFactor: .9),
              style: FilledButton.styleFrom(
                  backgroundColor: _colors[5], shape: CircleBorder())),
        ]),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            MyApp.of(context).changeThemeColor(currentColor);
            Navigator.pop(subContext, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            //todo - maybe save chosen color to account here?
            Navigator.pop(subContext, 'Confirm');
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
