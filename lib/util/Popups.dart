import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:money_mate/UserState.dart';
import 'package:money_mate/util/HTTPRequestBuilder.dart';
import '../main.dart';
import '../models/models.dart';
import 'StateManagement.dart';

/// A popup that allows the user to change the name and amount of an expense.
void updateExpensePopup(
    {required Prop<Expense> expense, required BuildContext context}) {
  FilePickerResult? result;
  Uint8List image = expense.value.image;
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                icon: Icon(Icons.euro),
                labelText: 'Amount',
              ),
              initialValue: expense.value.amount.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                } else if (num.tryParse(value) == null) {
                  return "Please enter a valid number";
                } else {
                  amount = value;
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () async {
                result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png'],
                );
                if (result != null) {
                  // Get the selected file path
                  String filePath = result!.files.single.path!;

                  // Read the file as bytes
                  image = await File(filePath).readAsBytes();
                }
              },
              child: const Text('Select Image'),
            ),
            Container(
              height: 100,
              width: 100,
              child: image.isNotEmpty
                  ? Image.memory(
                      image,
                      fit: BoxFit.cover,
                    )
                  : const Text('No image selected.'),
            )],
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
              UserState.of(context).expendList.updateItem(
                  expense: expense, name: name, amount: double.parse(amount), image: image);
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
  Uint8List imageBytes = Uint8List(0);
  late int categoryId;
  final formKey = GlobalKey<FormState>();
  FilePickerResult? result;
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) => AlertDialog(
      title: const Text('Add Expense'),
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                icon: Icon(Icons.euro),
                hintText: 'Amount of your Expense',
                labelText: 'Amount',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pleas enter a number';
                } else if (double.tryParse(value) == null) {
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
                hintStyle: TextStyle(overflow: TextOverflow.fade),
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
            TextButton(
              onPressed: () async {
                result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png'],
                );
                if (result != null) {
                  // Get the selected file path
                  String filePath = result!.files.single.path!;

                  // Read the file as bytes
                  File image = File(filePath);
                  imageBytes = await image.readAsBytes();
                  UserState.of(context).builder.createImage(file: image);
                }
              },
              child: const Text('Select Image'),
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
                  amount: num.parse(amount),
                  categoryId: categoryId,
                  image: imageBytes);
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

void deleteCategoryPopup({ required Category category, required BuildContext context}){
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) =>
        AlertDialog(
          title: const Text('Delete category'),
          content: const Text('All data in this category will be lost!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                UserState.of(context).removeCategory(category);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Hud()),);
              },
              child: const Text('OK'),
            ),
          ],
        ),
  );
}

void connectivityPopup({required BuildContext context}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext subContext) =>
        AlertDialog(
          title: const Text('No connectivity found'),
          content: const Text('If this error persists, check your phones network connection'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
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

Color getBackgroundColor(context) {
  if(Theme.of(context).brightness == Brightness.dark) {
    return Color(0xff201a18);
    //dark: color: Color(0xffe8e2d9)
  } else {
    return Color(0xfffffbff);
    //light: color: Color(0xff1d1b16)
  }
}

List<Color> getSystemColor(context) {
  if(SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark) {
    return [Color(0xff201a18), Color(0xffe8e2d9)]; //dark (first is backgroundColor, second is textColor)
  } else {
    return [Color(0xfffffbff), Color(0xff1d1b16)]; //light (first is backgroundColor, second is textColor)
  }
}

void colorPicker(
    {required Color currentColor, required ThemeMode currentThemeMode, required BuildContext context}) {
  List<Color> _colors = MyApp.of(context).getThemeColors();
  List<bool> _selection = List.generate(3, (index) => false); //List for switching app design
  _selection[MyApp.of(context).getThemeModes().indexOf(MyApp.of(context).getCurrentThemeMode())] = true;

  Color _newColor = MyApp.of(context).getCurrentThemeColor();
  ThemeMode _newTheme = MyApp.of(context).getCurrentThemeMode();
  Color _backgroundColor = Theme.of(context).dialogBackgroundColor;
  Color? _textColor = Theme.of(context).textTheme.displayLarge?.color;

  bool _isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: _backgroundColor,
              surfaceTintColor: _newColor,
              iconColor: _newColor,
              titleTextStyle: TextStyle(color: _textColor),
              contentTextStyle: TextStyle(color: _textColor),
              title: const Text('Theme Settings', style: TextStyle(fontSize: 20),),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 25),
                    Text(
                        'Choose your Theme Color', textAlign: TextAlign.center, style: TextStyle(color: _textColor)),
                    SizedBox(height: 10),
                    //todo - find a way to highlight the selected button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[0];}),
                            child: Text('Red', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[0],
                                shape: CircleBorder())),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[1];}),
                            child: Text('Purple', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[1],
                                shape: CircleBorder())
                        ),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[2];}),
                            child: Text('Blue', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[2],
                                shape: CircleBorder())
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[3];}),
                            child: Text('Green', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[3],
                                shape: CircleBorder())),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[4];}),
                            child: Text('Yellow', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[4],
                                shape: CircleBorder())),
                        FilledButton(
                            onPressed: () => setState(() {_newColor = _colors[5];}),
                            child: Text('Brown', textScaleFactor: .9, style: TextStyle(color: _isDark ? Colors.black87 : Colors.white.withAlpha(200))),
                            style: FilledButton.styleFrom(
                                backgroundColor: _colors[5],
                                shape: CircleBorder())),

                      ],
                    ),
                    SizedBox(height: 25),
                    Divider(color: _newColor.withAlpha(100)),
                    SizedBox(height: 25),
                    Text('Choose your Theme Mode', textAlign: TextAlign.center, style: TextStyle(color: _textColor)),
                    SizedBox(height: 10),
                    Center(
                        child: ToggleButtons(
                          color: _isDark ? Colors.white70 : Colors.black87,
                          selectedColor: _newColor,
                          borderColor: _isDark ? Colors.white10 : Colors.black12,
                          selectedBorderColor: _isDark ? Colors.white12 : Colors.black12,
                          fillColor: _newColor.withAlpha(30),
                          children: [
                            Icon(Icons.light_mode),
                            Icon(Icons.dark_mode),
                            Icon(Icons.app_shortcut)
                          ],
                          isSelected: _selection,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8)),
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0; i < _selection.length; i++) {
                                _selection[i] = i == index;
                              }
                              switch (index) {
                                case 0:
                                  setState(() {_newTheme = ThemeMode.light;
                                  _backgroundColor = Color(0xfffffbff);
                                  _textColor = Color(0xff1d1b16);
                                  _isDark = false;
                                  });
                                  break;
                                case 1:
                                  setState(() {_newTheme = ThemeMode.dark;
                                  _backgroundColor = Color(0xff201a18);
                                  _textColor = Color(0xffe8e2d9);
                                  _isDark = true;
                                  });
                                  break;
                                case 2:
                                  setState(() {_newTheme = ThemeMode.system;
                                  _backgroundColor = getSystemColor(context)[0];
                                  _textColor = getSystemColor(context)[1];
                                  _isDark = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
                                  });
                                  break;
                              }
                            });
                          },
                        )
                    ),
                    SizedBox(height: 25),
                  ]),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    int count = 0;
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
                  },
                  child: Text('Cancel', selectionColor: _newColor, style: TextStyle(color: _newColor)),
                ),
                TextButton(
                  onPressed: () {
                    int count = 0;
                    MyApp.of(context).changeTheme(_newColor, _newTheme);
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
                  },
                  child: Text('Confirm', style: TextStyle(color: _newColor)),
                ),
              ],
            );
          });
    });
}